#!/bin/bash

if [ "$(whoami)" != "root" ]
then 
	echo -e "You must be root to run this script"
	exit 1
fi

docker version > /dev/null
if [ $? -eq 0 ] 
then
	echo -e "docker exist"
else
	yum install docker-io -y
	if [ $? -eq 0 ] 
	then 
 		echo -e "docker install success"
	else
		echo -e "docker install fail"
		exit 1
	fi

fi

DOCKER_STATUS=`service docker status`
strRUN="running"
if [[ $DOCKER_STATUS == *$strRUN* ]]
then
	echo -e "docker is running"
else
	service docker start
	if [ $? -eq 0 ] 
	then 
		echo -e "docker service start success"
	else
		echo -e "docker service fail to start"
		exit 1
	fi

fi 

INSTALLED_IMAGES=`docker images`
strIMAGES="dinotools/dionaea-docker"
if [[ $INSTALLED_IMAGES == *$strIMAGES* ]]
then 
	echo -e "dintools already installed"
else
	docker pull dinotools/dionaea-docker
	if [ $? -eq 0 ] 
	then 
		echo -e "docker dionaea-docker success"
	else 
		echo -e "docker dionaea-docker failed to pull"
		exit 1
	fi

fi

echo ">>>>>>>>>>>now start to pull install the server"

echo ">>now install python2.7 if you havenot "

PYVERSION=`python -c "import sys;print sys.version"`
strVERSION="2.7"
if [[ $PYVERSION == $strVERSION* ]]
then
	echo -e "Python2.7 is already installed"
else
	python2.7 -c "import sys;print sys.version"
	if [ $? -eq 0 ]
	then
		echo -e "Python2.7 is installed in you environment"
	else
		cd /opt
		wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
		if [ $? -eq 0 ]
		then
			tar xvf Python-2.7.12.tgz
			yum install openssl-devel -y
			yum install gcc -y
			if [ $? -eq 0 ]
			then 
				cd Python-2.7.12
				./configure --enable-unicode=ucs4 --with-ssl && make && make install
				if [ $? -eq 0 ]
				then
					echo -e "Python2.7 is successful installed"
				else
					echo -e "Python2.7 is not installed because of make"
					exit 1
				fi

			else
				echo -e "Python2.7 is not installed because of yum installed package"
				exit 1
			fi
	
		else
			echo -e "Python2.7 is not wgeted, may be the network wrong"
			exit 1
		fi
	fi

fi

cd ..
PIPVERSION=`pip2.7 --version`
strPIP="python2.7"
if [[ $PIPVERSION == *$strPIP* ]]
then
	echo -e "pip2.7 for python2.7 is installed"
else
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	if [ $? -eq 0 ]
	then
		python2.7 get-pip.py
		if [ $? -eq 0 ]
		then
			echo -e "pip2.7 is installed successful"
		else
			echo -e "pip2.7 is not installed "
			exit 1
		fi

	else
		echo -e "pip2.7 is wrong with download get-pip.py"
		exit 1
	fi

fi


git --version
if [ $? -eq 0 ]
then
	echo -e "git already exist"
else
	wget https://github.com/git/git/archive/master.zip
	if [ $? -eq 0 ]
	then
		unzip master.zip
		if [ $? -eq 0 ]
		then
			cd master
			make prefix=/usr install install-doc install-html install-info
			if [ $? -eq 0 ]
	        then
				make configure
				./configure
				make all doc
			else 
				echo -e "git make configure error"
				exit 1
			fi

		else
			echo -e "unzip master.zip error"
			exit 1
		fi
	
	else
		echo -e "error to wget git"
		exit 1
	fi

fi

cd /opt
cd honeypotinstall
if [ $? -eq 0 ]
then 
	echo -e "honeypotinstall already exists"
else
	git clone https://github.com/iph0n3/honeypotinstall.git
	if [ $? -eq 0 ]
	then
		cd honeypotinstall
	else
		echo -e "honeypotinstall error to wget"
		exit 1
	fi

fi
	pip2.7 install -r requirements.txt
	if [ $? -eq 0 ]
	then
		echo -e "pip installed succcccful all packages"
	else
		echo -e "pip install error"
		exit 1
	fi


# npm && less
lessc --version
if [ $? -eq 0 ]
then
	echo -e "less already exists"
else
	npm --version > /dev/null
	if [ $? -eq 0 ]
	then 
		echo -e "npm already exist"
	else
		yum install npm -y
		if [ $? -eq 0 ] 
		then 
			echo -e "npm is installed successful"
		else
			echo -e "npm install error"
		fi 

	fi 
		npm config set strict-ssl false
		npm install -g less
		if [ $? -eq 0 ]
		then 
			echo -e "less is installed"
		else
			echo -e "error to install less"
			exit 1
		fi

fi


#python-netaddr
yum install python-netaddr -y
if [ $? -eq 0 ]
then
	echo -e "python-netaddr is installed successful"
else
	echo -e "python-netaddr is error"
	exit 1
fi

#DionaeaFR
echo ">>> now start to install DionaeaFR"
ls /opt/DionaeaFR/.git
if [ $? -eq 0 ]
then
	echo -e "DionaeaFR is downloaded!"
else
	cd /opt
	git clone https://github.com/rubenespadas/DionaeaFR
	if [ $? -eq 0 ]
	then
	        echo -e "DionaeaFR is loaded"
	else
	        echo -e "DionaeaFR is error"
	        exit 1
	fi

fi

#GeoLiteCity && GeoIP
ls /opt/DionaeaFR/DionaeaFR/static/GeoIP.dat && ls /opt/DionaeaFR/DionaeaFR/static/GeoLiteCity.dat
if [ $? -eq 0]
then
	echo -e "GeoIP.dat and GeoLiteCity.dat is already mv to /opt/DionaeaFR/DionaeaFR/static"
else
	wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
	if [ $? -eq 0 ]
	then 
		wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
		if [ $? -eq 0 ]
		then
			gunzip GeoLiteCity.dat.gz && gunzip GeoIP.dat.gz
			mv GeoIP.dat DionaeaFR/DionaeaFR/static && mv GeoLiteCity.dat DionaeaFR/DionaeaFR/static
		else
			echo -e "unzip error"
			exit 1
		fi
	else
		echo -e "wget GeoliteCity.dat.gz error"
		exit 1
	fi

fi
