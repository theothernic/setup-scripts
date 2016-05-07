#! /usr/bin/env bash


if [ -f /etc/os-release ]; then
	source /etc/os-release;
else
	echo "Cannot find the /etc/os-release file. Stopping.";
	exit 1000;
fi

echo "OS ID: ${ID}";

case ${ID} in
	"ubuntu")
	echo "setting up Ubuntu-specific commands";
	INSTALL_PKGMGR="apt-get";
	INSTALL_PKGMGR_FORCE_FLAG="-y";
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
	if [ $id -eq "ubuntu" ]; then
		sudo ${INSTALL_PKGMGR} update;
	fi
	
	sudo ${INSTALL_PKGMGR} ${INSTALL_PKGMGR_FORCE_FLAG} upgrade;
}

## EXECUTIONARY.
inst_update_system()

