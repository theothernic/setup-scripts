#! /usr/bin/env bash


if [ -f /etc/os-release ]; then
	source /etc/os-release;
else
	echo "Cannot find the /etc/os-release file. Stopping.";
	exit 1000;
fi


case "$id" in
	ubuntu)
	echo "setting up Ubuntu-specific commands";
	INSTALL_PKGMGR="apt-get";
	INSTALL_PKGMGR_FORCE_FLAG="-y";
	;;

	redhat)
	echo "setting up RH-specific commands";
	INSTALL_PKGMGR="yum";
	;;

	*)
	echo "Your distro is not yet supported.";
	exit 1001;
esac


install_system_update()
{
	# if this system is debian-based, make sure that apt has the latest mirrors.
	if [ $id -eq "ubuntu" ]; then
		sudo ${INSTALL_PKGMGR} update;
	fi
	
	sudo ${INSTALL_PKGMGR} ${INSTALL_PKGMGR_FORCE_FLAG} upgrade;
}

install_system_update();


