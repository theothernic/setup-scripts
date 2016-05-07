#! /usr/bin/env bash

### setup-generic-web.sh
### written by Nicholas Barr, 2016-05-06.

# INSTALL FLAGS.
INSTALL_FLAG_PKG_PHP=true;
INSTALL_FLAG_PKG_NODEJS=true;

INSTALL_WEB_SERVER="nginx";
INSTALL_DB_SERVER="mariadb";


Z_INSTALL_DB_ROOT_PASS="password";
Z_INSTALL_REQUIRE_RESTART=false;

if [ -f /etc/os-release ]; then
	source /etc/os-release;
else
	echo "Cannot find the /etc/os-release file. Stopping.";
	exit 1000;
fi

# SETUP SPECIFIC FUNCTIONALITY.
setup_ubuntu()
{
	# exports first!
	export DEBIAN_FRONTEND=noninteractive;

	# set up apt as the package manager.
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
		debconf-set-selections <<< "mariadb-server mysql-server/root_password password ${Z_INSTALL_DB_ROOT_PASS}";
		debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password ${Z_INSTALL_DB_ROOT_PASS}";
		INSTALL_PKG_DB_SERVER="mariadb-server";
	fi

	# things can differ between versions here.
	# TODO: convert to a case statement because of numerous versions.
	if [ "${VERSION_ID}" == "14.04" ]; then

		# apache has a module for php.
		if [ ${INSTALL_WEB_SERVER} == "apache" ]; then
			PHP_HANDLER="libapache2-mod-php5";
		else
			PHP_HANDLER="php5-fpm";
		fi

		INSTALL_PKG_PHP="${PHP_HANDLER} php5-cli php5-gd php5-mysql php5-pgsql php5-intl php5-mcrypt";
	elif [ "${VERSION_ID}" == "16.04" ]; then

		# apache has a module for php.
		if [ ${INSTALL_WEB_SERVER} == "apache" ]; then
			PHP_HANDLER="libapache2-mod-php";
		else
			PHP_HANDLER="php7.0-fpm";
		fi

		INSTALL_PKG_PHP="${PHP_HANDLER} php7.0-cli php7.0-gd php7.0-mysql php7.0-pgsql php7.0-intl";
	fi

	INSTALL_PKG_BUILDTOOLS="build-essential";
	INSTALL_PKG_NODEJS="nodejs";
	INSTALL_PKG_NODEJS_URL="https://deb.nodesource.com/setup_6.x";

	Z_INSTALL_SETUP_READY=true;
}

setup_redhat()
{
	INSTALL_PKGMGR="yum";

	INSTALL_PKG_BUILDTOOLS="gcc-c++ make";
	INSTALL_PKG_NODEJS="nodejs";
	INSTALL_PKG_NODEJS_URL="https://rpm.nodesource.com/setup_6.x";

	Z_INSTALL_SETUP_READY=true;
}

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
	if [ "${ID}" == "ubuntu" ]; then
		sudo ${INSTALL_PKGMGR} update;
	fi
}

inst_upgrade_system()
{
	sudo ${INSTALL_PKGMGR} ${INSTALL_PKGMGR_FORCE_FLAG} upgrade;
}

inst_build_tools()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} "${INSTALL_PKG_BUILDTOOLS}";
}

inst_install_web_server()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} "${INSTALL_PKG_WEB_SERVER}";
}

inst_install_db_server()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} "${INSTALL_PKG_DB_SERVER}";
}

inst_install_php()
{
	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_PHP};
}

inst_install_composer()
{
	if [ -f /usr/bin/php ]; then
		sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
		sudo php composer-setup.php;
		sudo rm -f composer-setup.php;

		if [ -f composer.phar ]; then
			sudo mv composer.phar /usr/local/bin/composer;
		fi
	fi
}

inst_install_nodejs()
{
	if [ "${ID}" == "ubuntu" ]; then
		curl -sL ${INSTALL_PKG_NODEJS_URL} | sudo -E bash -;
		inst_update_system;
	fi

	sudo ${INSTALL_PKGMGR} install ${INSTALL_PKGMGR_FORCE_FLAG} ${INSTALL_PKG_NODEJS};
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
if [ ${Z_INSTALL_SETUP_READY} ]; then
	inst_update_system;
	inst_build_tools;
	inst_install_db_server;
	inst_install_web_server;

	# these packages are toggled with flags at the beginning of the script.
	if [ ${INSTALL_FLAG_PKG_NODEJS} ]; then
		inst_install_nodejs;
	fi

	if [ ${INSTALL_FLAG_PKG_PHP} ]; then
		inst_install_php;
		inst_install_composer;
	fi

	if [ ${Z_INSTALL_REQUIRE_RESTART} ]; then
		inst_restart_machine;
	fi
else
	echo "Script setup did not prepare correctly. Check to make sure that everything is working okay.";
	exit 2001;
fi


