#! /usr/bin/env bash


if [ -f /etc/os-release ]; then
	source /etc/os-release;
else
	echo "Cannot find the /etc/os-release file. Stopping.";
	exit 1000;
fi

INSTALL_WEB_SERVER="apache";
INSTALL_DB_SERVER="mariadb";

case ${ID} in
	"ubuntu")
	echo "setting up Ubuntu-specific commands";
	INSTALL_PKGMGR="apt-get";
	INSTALL_PKGMGR_FORCE_FLAG="-y";
	

	# webserver choices.
	if [ ${INSTALL_WEB_SERVER} == "nginx" ]; then
		sudo add-apt-repository -y ppa:nginx/stable;
		INSTALL_PKG_WEB_SERVER="nginx";
	elif [ ${INSTALL_WEB_SERVER} == "apache" ]; then
		INSTALL_PKG_WEB_SERVER="apache2";
	fi


	# things can differ between versions here.
	if [ ${VERSION_ID} == "14.04" ]; then
		INSTALL_PKG_PHP="php5-fpm php5-cli php5-gd php5-mysql php5-pgsql php5-intl";
	elif [ ${VERSION_ID} == "16.04" ]; then
		INSTALL_PKG_PHP="php7.0-fpm php7.0-cli php7.0-gd php7.0-mysql php7.0-pgsql php7.0-intl";
	fi
	;;

	"redhat")
	echo "setting up RH-specific commands";
	INSTALL_PKGMGR="yum";
	;;
esac

if [ -z ${INSTALL_PKGMGR} ]; then
	echo "Your distro is not currently supported.";
	exit 1001;
fi

### FUNCTIONS.
inst_update_system()
{
	# if this system is debian-based, make sure that apt has the latest mirrors.
	if [ ${ID} == "ubuntu" ]; then
		sudo ${INSTALL_PKGMGR} update;
	fi
	
	sudo ${INSTALL_PKGMGR} ${INSTALL_PKGMGR_FORCE_FLAG} upgrade;
}

inst_install_web_server()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_WEB_SERVER}
}

inst_install_php()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_WEB_SERVER}
}


## EXECUTIONARY.
inst_update_system
inst_install_web_server
inst_install_php
