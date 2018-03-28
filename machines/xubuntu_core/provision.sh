#!/usr/bin/env bash

sudo apt-get update

if ! [[ -f ~/.xubuntu-installed ]]
then
	sudo apt-get install -y xubuntu-core^
	touch ~/.xubuntu-installed
	# sudo apt-get install -y open-vm-tools-desktop
	# sudo reboot

	# reinstall vmware tools
	sudo vmware-tools-distrib/vmware-install.pl --force-install --default
fi 

echo "Xubuntu installed, adding packages"

echo "Installing Google Chrome browser"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable

echo "Installing basics"
sudo apt-get install -y vim 
sudo apt-get install -y xz-utils

echo "Installing Telegram"
if ! [[ -d ~/Telegram ]]
then
	wget -nd -nv -O telegram64.tar.xz https://telegram.org/dl/desktop/linux
	tar -xJf telegram64.tar.xz
	rm telegram64.tar.xz
fi

echo ""
echo "------------------------------------"
echo "$ vagrant reload to reboot into XFCE"
echo "------------------------------------"