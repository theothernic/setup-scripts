#! /usr/bin/env bash


if [ -f /etc/os-release ]; then
	source /etc/os-release;
else
	echo "Cannot find the /etc/os-release file. Stopping.";
	exit 1000;
fi

# SETUP SPECIFIC FUNCTIONALITY.
setup_ubuntu()
{
	INSTALL_PKGMGR="apt-get";
	INSTALL_PKGMGR_FORCE_FLAG="-y";
	

	# webserver choices.
	if [ ${INSTALL_WEB_SERVER} == "nginx" ]; then
		sudo add-apt-repository -y ppa:nginx/stable;
		INSTALL_PKG_WEB_SERVER="nginx";
	elif [ ${INSTALL_WEB_SERVER} == "apache" ]; then
		INSTALL_PKG_WEB_SERVER="apache2";
	fi

	# forcing the install of MariaDB, Oracle sucks (imho) and Percona is...weird.
	if [ ${INSTALL_DB_SERVER} == "mysql" ] || [ ${INSTALL_DB_SERVER} == "mariadb" ]; then
		INSTALL_PKG_DB_SREVER="mariadb-server";
	fi

	# things can differ between versions here.
	if [ ${VERSION_ID} == "14.04" ]; then
		INSTALL_PKG_PHP="php5-fpm php5-cli php5-gd php5-mysql php5-pgsql php5-intl";
	elif [ ${VERSION_ID} == "16.04" ]; then
		INSTALL_PKG_PHP="php7.0-fpm php7.0-cli php7.0-gd php7.0-mysql php7.0-pgsql php7.0-intl";
	fi
}

setup_redhat()
{
	INSTALL_PKGMGR="yum";
}

INSTALL_WEB_SERVER="apache";
INSTALL_DB_SERVER="mariadb";

case ${ID} in
	"ubuntu")
	echo "setting up Ubuntu-specific commands";
	setup_ubuntu;
	;;

	"redhat")
	echo "setting up RH-specific commands";
	setup_redhat;
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

inst_install_db_server()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_DB_SERVER}
}

inst_install_php()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_WEB_SERVER}
}

# inst_extra_sources()
# {
# 	if [ -d "./src" ]; then
# 		for source_file in $(ls -l ./src); do
# 			echo ${SOURCE_FILE};
# 		done;
# 	fi
# }

inst_restart_machine()
{
	sudo shutdown -r now;
}


## EXECUTIONARY.
if [ ${INSTALL_SETUP_READY} == true ]; then



	if [ ${INSTALL_REQUIRE_RESTART} == true ]; then
		inst_restart_machine;
	fi
else
	echo "Script setup did not prepare correctly. Check to make sure that everything is working okay.";
	exit 2001;
fi


