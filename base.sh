#!/bin/bash
# Author Munis Isazade Django developer
VERSION="1.4.4"
ERROR_STATUS=0
ROOT_DIRECTION=$(pwd)
ISSUE_URL="https://github.com/munisisazade/create-django-app/issues"


#usage: ChangeColor $COLOR text/background
function ChangeColor()
{
	TYPE=""
	case "$2" in
	"text") TYPE="setaf"
	;;
	"back") TYPE="setab"
	;;
	*) TYPE="setaf"
	esac



	case "$1" in
	"red") tput "$TYPE" 1
	;;
	"orange") tput "$TYPE" 3
	;;
	"blue") tput "$TYPE" 4
	;;
	"green") tput "$TYPE" 2
	;;
	"black") tput "$TYPE" 0
	;;
	"white") tput "$TYPE" 7
	;;
	"magenta") tput "$TYPE" 5
	;;
	"cyan") tput "$TYPE" 7
	;;
	*) tput "$TYPE" 0
	esac
}

# echo -e "$(ChangeColor red text) RED $(ChangeColor white text)"
# echo -e "$(ChangeColor orange text) Orange $(ChangeColor white text)"
# echo -e "$(ChangeColor blue text) Blue $(ChangeColor white text)"
# echo -e "$(ChangeColor green text) Green $(ChangeColor white text)"
# echo -e "$(ChangeColor black text) Black $(ChangeColor white text)"
# echo -e "$(ChangeColor white text) White $(ChangeColor white text)"
# echo -e "$(ChangeColor magenta text) Magenta $(ChangeColor white text)"
# echo -e "$(ChangeColor cyan text) Cyan $(ChangeColor white text)"

function usage {
    echo -e "Please specify the project directory:"
    echo -e "$(ChangeColor blue text)  create-django-app $(ChangeColor green text)<project-directory>$(ChangeColor white text)"
    echo -e "\n"
    echo -e "For example:"
    echo -e "$(ChangeColor blue text)  create-django-app $(ChangeColor green text)my-django-app$(ChangeColor white text)"
    echo -e "\n"
	echo -e "Run $(ChangeColor blue text)create-django-app --help$(ChangeColor white text) to see all options."

    exit 1
}

function helping {
	echo -e "\n"
	echo -e " Usage: create-react-app $(ChangeColor green text)<project-directory>$(ChangeColor white text) [options]"
  	echo -e "\n"
  	echo -e " Options:"
  	echo -e "\n"
  	echo -e "  -V, --version                            output the version number"
  	echo -e "  --verbose                                print additional logs"
  	echo -e "  -h, --help                               output usage information"
  	echo -e "  -a, --author                             about author information"
  	echo -e "  Only $(ChangeColor green text)<project-directory>$(ChangeColor white text) is required."
  	echo -e "\n"
  	echo -e "  If you have any problems, do not hesitate to file an issue:"
  	echo -e "    $(ChangeColor blue text)$ISSUE_URL$(ChangeColor white text)"


}


#function Get version
function get_version {
	echo -e "$VERSION"
}

function get_author {
	echo -e "Munis Isazade       <munisisazade@gmail.com>"
}

function base_script {
	FILE=$1
	if [ -d $FILE ]; then
	   echo "The directory $(ChangeColor green text)$FILE$(ChangeColor white text) contains files that could conflict:$(ChangeColor red text)"
	   cd $FILE
	   ls
	   echo -e "\n"
	   echo -e "$(ChangeColor white text)Either try using a new directory name, or remove the files listed above"
	   exit 1
	else
	    echo "File $FILE does not exist."
	    echo "Creating File ..."
	    mkdir $FILE
	    echo -e "Get into $FILE"
	    cd $FILE
	    echo -e "First create virtual enviroment"
	    progress30
		python3 -m venv .venv
		echo -e "Swich virtualenviroment"
		source .venv/bin/activate
		echo -e "Installing Django and Pillow with pip library"
		pip install django pillow gunicorn uwsgi
		echo -e "Updating pip library .."
		pip install -U pip
		read -p "Do you want to install aditional package (y,n)?" aditional
		if [ "$aditional" == y ] ; then
		    echo -e "Aditional package install"
		    read -p "Package name or names: " packages_list
		    pip install $packages_list
		fi
		echo -e "Create requirement.txt"
		pip freeze > requirements.txt
		AUTHOR_NAME="Munis Isazade      <munisisazade@gmail.com>    Senior Django developer"
		echo $AUTHOR_NAME >> contributors.txt
		echo "Creating .gitignore file"
		echo ".idea/" >> .gitignore
		echo ".venv" >> .gitignore
		echo "db.sqlite3" >> .gitignore
		read -p "Project name: " PROJ_NAME
		django-admin startproject $PROJ_NAME .
		echo -e "Create app"
		read -p "Django app name : " APP_NAME
		python manage.py startapp $APP_NAME
		echo -e "Creating Database .."
		python manage.py migrate
		progress30
		docker_container
		ask_git
		finish
	fi
}

function progress30 {
	echo -ne '                    (0%)\r'
	sleep 0.5
	echo -ne '##                  (10%)\r'
	sleep 0.5
	echo -ne '####                (20%)\r'
	sleep 0.5
	echo -ne '######              (30%)\r'
	sleep 0.5
	echo -ne '########            (40%)\r'
	sleep 0.5
	echo -ne '##########          (50%)\r'
	sleep 0.5
	echo -ne '############        (60%)\r'
	sleep 0.5
	echo -ne '##############      (70%)\r'
	sleep 0.5
	echo -ne '################    (80%)\r'
	sleep 0.5
	echo -ne '##################  (90%)\r'
	sleep 0.5
	echo -ne '####################(100%)\r'
	echo -ne '\n'
}

function docker_container {
	echo -e "Creating mime_types...  $(ChangeColor green text)OK$(ChangeColor white text)"
	mime_types
	echo -e "Creating docker_file...  $(ChangeColor green text)OK$(ChangeColor white text)"
	docker_file
	echo -e "Creating docker_compose... $(ChangeColor green text)OK$(ChangeColor white text)"
	docker_compose
	echo -e "Creating uwsgi_ini...  $(ChangeColor green text)OK$(ChangeColor white text)"
	uwsgi_ini
}

function mime_types {
	touch mime.types
	echo "# mime type definition extracted from nginx" >> mime.types
	echo "# https://github.com/nginx/nginx/blob/master/conf/mime.types" >> mime.types
	echo "" >> mime.types
	echo "text/html                             html htm shtml" >> mime.types
	echo "text/css                              css" >> mime.types
	echo "text/xml                              xml" >> mime.types
	echo "image/gif                             gif" >> mime.types
	echo "image/jpeg                            jpeg jpg" >> mime.types
	echo "application/javascript                js" >> mime.types
	echo "application/atom+xml                  atom" >> mime.types
	echo "application/rss+xml                   rss" >> mime.types
	echo "" >> mime.types
	echo "text/mathml                           mml" >> mime.types
	echo "text/plain                            txt" >> mime.types
	echo "text/vnd.sun.j2me.app-descriptor      jad" >> mime.types
	echo "text/vnd.wap.wml                      wml" >> mime.types
	echo "text/x-component                      htc" >> mime.types
	echo "" >> mime.types
	echo "image/png                             png" >> mime.types
	echo "image/tiff                            tif tiff" >> mime.types
	echo "image/vnd.wap.wbmp                    wbmp" >> mime.types
	echo "image/x-icon                          ico" >> mime.types
	echo "image/x-jng                           jng" >> mime.types
	echo "image/x-ms-bmp                        bmp" >> mime.types
	echo "image/svg+xml                         svg svgz" >> mime.types
	echo "image/webp                            webp" >> mime.types
	echo "" >> mime.types
	echo "application/font-woff                 woff" >> mime.types
	echo "application/java-archive              jar war ear" >> mime.types
	echo "application/json                      json" >> mime.types
	echo "application/mac-binhex40              hqx" >> mime.types
	echo "application/msword                    doc" >> mime.types
	echo "application/pdf                       pdf" >> mime.types
	echo "application/postscript                ps eps ai" >> mime.types
	echo "application/rtf                       rtf" >> mime.types
	echo "application/vnd.apple.mpegurl         m3u8" >> mime.types
	echo "application/vnd.ms-excel              xls" >> mime.types
	echo "application/vnd.ms-fontobject         eot" >> mime.types
	echo "application/vnd.ms-powerpoint         ppt" >> mime.types
	echo "application/vnd.wap.wmlc              wmlc" >> mime.types
	echo "application/vnd.google-earth.kml+xml  kml" >> mime.types
	echo "application/vnd.google-earth.kmz      kmz" >> mime.types
	echo "application/x-7z-compressed           7z" >> mime.types
	echo "application/x-cocoa                   cco" >> mime.types
	echo "application/x-java-archive-diff       jardiff" >> mime.types
	echo "application/x-java-jnlp-file          jnlp" >> mime.types
	echo "application/x-makeself                run" >> mime.types
	echo "application/x-perl                    pl pm" >> mime.types
	echo "application/x-pilot                   prc pdb" >> mime.types
	echo "application/x-rar-compressed          rar" >> mime.types
	echo "application/x-redhat-package-manager  rpm" >> mime.types
	echo "application/x-sea                     sea" >> mime.types
	echo "application/x-shockwave-flash         swf" >> mime.types
	echo "application/x-stuffit                 sit" >> mime.types
	echo "application/x-tcl                     tcl tk" >> mime.types
	echo "application/x-x509-ca-cert            der pem crt" >> mime.types
	echo "application/x-xpinstall               xpi" >> mime.types
	echo "application/xhtml+xml                 xhtml" >> mime.types
	echo "application/xspf+xml                  xspf" >> mime.types
	echo "application/zip                       zip" >> mime.types
	echo "" >> mime.types
	echo "application/octet-stream              bin exe dll" >> mime.types
	echo "application/octet-stream              deb" >> mime.types
	echo "application/octet-stream              dmg" >> mime.types
	echo "application/octet-stream              iso img" >> mime.types
	echo "application/octet-stream              msi msp msm" >> mime.types
	echo "" >> mime.types
	echo "application/vnd.openxmlformats-officedocument.wordprocessingml.document    docx" >> mime.types
	echo "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet          xlsx" >> mime.types
	echo "application/vnd.openxmlformats-officedocument.presentationml.presentation  pptx" >> mime.types
	echo "" >> mime.types
	echo "audio/midi                            mid midi kar" >> mime.types
	echo "audio/mpeg                            mp3" >> mime.types
	echo "audio/ogg                             ogg" >> mime.types
	echo "audio/x-m4a                           m4a" >> mime.types
	echo "audio/x-realaudio                     ra" >> mime.types
	echo "" >> mime.types
	echo "video/3gpp                            3gpp 3gp" >> mime.types
	echo "video/mp2t                            ts" >> mime.types
	echo "video/mp4                             mp4" >> mime.types
	echo "video/mpeg                            mpeg mpg" >> mime.types
	echo "video/quicktime                       mov" >> mime.types
	echo "video/webm                            webm" >> mime.types
	echo "video/x-flv                           flv" >> mime.types
	echo "video/x-m4v                           m4v" >> mime.types
	echo "video/x-mng                           mng" >> mime.types
	echo "video/x-ms-asf                        asx asf" >> mime.types
	echo "video/x-ms-wmv                        wmv" >> mime.types
	echo "video/x-msvideo                       avi" >> mime.types
}

function docker_file {
	touch Dockerfile
	echo "FROM python:3.5-alpine" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Ensure that Python outputs everything that's printed inside" >> Dockerfile
	echo "# the application rather than buffering it." >> Dockerfile
	echo "ENV PYTHONUNBUFFERED 1" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Copy in your requirements file" >> Dockerfile
	echo "ADD requirements.txt /requirements.txt" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Install build deps, then run \`pip install\`, then remove unneeded build deps all in a single step. Correct the path to your production requirements file, if needed." >> Dockerfile
	echo "RUN set -ex \\" >> Dockerfile
	echo "    && apk add --no-cache --virtual .build-deps \\" >> Dockerfile
	echo "              gcc g++ \\" >> Dockerfile
	echo "              make \\" >> Dockerfile
	echo "              libc-dev \\" >> Dockerfile
	echo "              musl-dev \\" >> Dockerfile
	echo "              linux-headers \\" >> Dockerfile
	echo "              pcre-dev \\" >> Dockerfile
	echo "              postgresql-dev \\" >> Dockerfile
	echo "              jpeg-dev \\" >> Dockerfile
	echo "              zlib-dev \\" >> Dockerfile
	echo "              freetype-dev \\" >> Dockerfile
	echo "              lcms2-dev \\" >> Dockerfile
	echo "              openjpeg-dev \\" >> Dockerfile
	echo "              tiff-dev \\" >> Dockerfile
	echo "              tk-dev \\" >> Dockerfile
	echo "              tcl-dev \\" >> Dockerfile
	echo "              harfbuzz-dev \\" >> Dockerfile
	echo "              fribidi-dev \\" >> Dockerfile
	echo "    && pyvenv /venv \\" >> Dockerfile
	echo "    && /venv/bin/pip install -U pip \\" >> Dockerfile
	echo '    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install --no-cache-dir -r /requirements.txt" \' >> Dockerfile
	echo '    && runDeps="$( \\\' >> Dockerfile
	echo "            scanelf --needed --nobanner --recursive /venv \\" >> Dockerfile
	echo "                    | awk '{ gsub(/,/, \"\nso:\", \$2); print \"so:\" \$2 }' \\" >> Dockerfile
	echo "                    | sort -u \\" >> Dockerfile
	echo "                    | xargs -r apk info --installed \\" >> Dockerfile
	echo "                    | sort -u \\" >> Dockerfile
	echo "    )\" \\" >> Dockerfile
	echo "    && apk add --virtual .python-rundeps \$runDeps \\" >> Dockerfile
	echo "    && apk del .build-deps" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)" >> Dockerfile
	echo "RUN mkdir /code/" >> Dockerfile
	echo "WORKDIR /code/" >> Dockerfile
	echo "ADD . /code/" >> Dockerfile
	echo "COPY mime.types /etc/mime.types" >> Dockerfile
	echo "" >> Dockerfile
	echo "# uWSGI will listen on this port" >> Dockerfile
	read -p "Which port do you want to use(choose range 8000~8999)?" DOCKER_PORT
	if [ "$DOCKER_PORT" == '' ] ; then
	    DOCKER_PORT=8050
	fi
	echo "EXPOSE $DOCKER_PORT" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):" >> Dockerfile
	echo "RUN if [ -f manage.py ]; then /venv/bin/python manage.py collectstatic --noinput; fi" >> Dockerfile
	echo "" >> Dockerfile
	echo "# Start uWSGI" >> Dockerfile
	echo "CMD [ \"/venv/bin/uwsgi\", \"--ini\", \"/code/uwsgi.ini\"]" >> Dockerfile
}

function docker_compose {
	touch docker-compose.yml
	echo "version: '3'" >> docker-compose.yml
	echo "" >> docker-compose.yml
	echo "services:" >> docker-compose.yml
	echo "  web:" >> docker-compose.yml
	echo "    container_name: $PROJ_NAME" >> docker-compose.yml
	echo "    build: ." >> docker-compose.yml
	echo "    restart: \"always\"" >> docker-compose.yml
	echo "    environment:" >> docker-compose.yml
	echo "      - DEBUG=True" >> docker-compose.yml
	echo "      - TIMEOUT=300" >> docker-compose.yml
	echo "      - HTTP_PORT=$DOCKER_PORT" >> docker-compose.yml
	OTHERPORT=`expr $DOCKER_PORT+1`
	echo "      - STATS_PORT=$OTHERPORT" >> docker-compose.yml
	echo "    volumes:" >> docker-compose.yml
	echo "      - .:/code" >> docker-compose.yml
	echo "    ports:" >> docker-compose.yml
	echo "      - \"$DOCKER_PORT:$DOCKER_PORT\"" >> docker-compose.yml
}

function uwsgi_ini {
	touch uwsgi.ini
	echo "[uwsgi]" >> uwsgi.ini
	echo "env = DJANGO_SETTINGS_MODULE=drongo.settings" >> uwsgi.ini
	echo "env = UWSGI_VIRTUALENV=/venv" >> uwsgi.ini
	echo "env = IS_WSGI=True" >> uwsgi.ini
	echo "env = LANG=en_US.UTF-8" >> uwsgi.ini
	echo "workdir = /code" >> uwsgi.ini
	echo "chdir = /code" >> uwsgi.ini
	echo "module = drongo.wsgi:application" >> uwsgi.ini
	echo "master = True" >> uwsgi.ini
	echo "pidfile = /tmp/app-master.pid" >> uwsgi.ini
	echo "vacuum = True" >> uwsgi.ini
	echo "max-requests = 5000" >> uwsgi.ini
	echo "processes = 5" >> uwsgi.ini
	echo "cheaper = 2" >> uwsgi.ini
	echo "cheaper-initial = 5" >> uwsgi.ini
	echo "gid = root" >> uwsgi.ini
	echo "uid = root" >> uwsgi.ini
	echo "http-socket = 0.0.0.0:\$(HTTP_PORT)" >> uwsgi.ini
	echo "stats = 0.0.0.0:\$(STATS_PORT)" >> uwsgi.ini
	echo "harakiri = \$(TIMEOUT)" >> uwsgi.ini
	echo "print = Your timeout is %(harakiri)" >> uwsgi.ini
	echo "static-map = /static=%(workdir)/static" >> uwsgi.ini
	echo "if-exists = %(workdir)/media" >> uwsgi.ini
	echo "route = /media/(.*) media:%(workdir)/media/\$1" >> uwsgi.ini
}

function ask_git { 
	read -p "Do you have a github or bitbucket repository (y,n)?" check_git
	if [ "$check_git" == y ] ; then
	    echo -e "Add new repo to project"
	    read -p "Repository Url (https/git): " REPO_URL
	    if [ "$REPO_URL" != '' ] ; then
	    	echo -e "Create Empty Git repository"
	    	git init
	    	echo -e "Add $REPO_URL repository to $FILE"
	    	git remote add origin $REPO_URL
	    	echo -e "Add new files to repo"
	    	git add .
	    	echo -e "Add new files to repo"
	    	git commit -am "First commit $FILE"
	    	git push -u origin master
	    	git fetch
	    	echo -e "Check git status"
	    	git status
	    	echo -e "Check git branch"
	    	git branch
	    fi
	fi
}


function finish {
	echo -e "\n"
	echo -e " Successfuly created $(ChangeColor green text)$FILE$(ChangeColor white text) "
  	echo -e "\n"
  	echo -e " Django runserver project :"
  	echo -e "\n"
  	echo -e "  cd $(ChangeColor green text)$FILE$(ChangeColor white text)"
  	echo -e "  source .venv/bin/activate"
  	echo -e "  python manage.py runserver"
  	echo -e "\n"
  	echo -e "  If you have any problems, do not hesitate to file an issue:"
  	echo -e "    $(ChangeColor blue text)$ISSUE_URL$(ChangeColor white text)"


}



################
#### START  ####
################

COMMAND=${@:$OPTIND:1}


#CHECKING PARAMS VALUES
case ${COMMAND} in

	-a | --author)
		get_author
	;;

	-V | --version)
		get_version
	;;

    -h | --help)

		helping

	;;


    *)

        # if path not provided show usage message
	    if [ "$#" -ne 1 ]; then
            usage
        fi
        file_dir=${COMMAND}
        base_script ${file_dir}

	;;

	
esac

exit $ERROR_STATUS