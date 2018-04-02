#!/usr/bin/env bash

## This should be run on the guest directly; scp the file over

# first, patch sudoers
sudo patch /etc/sudoers < sudoers.patch

# then sshd_config
sudo patch /etc/ssh/sshd_config < sshd_config.patch

# then install open-vm-tools
sudo apt-get update
sudo apt-get install -y open-vm-tools

# then install VMWare Tools; connect the CD first!
# This is needed for the HGFS kernel module, even though we're using open-vm-tools for everything else
mkdir /tmp/vwcd
sudo mount /dev/sr0 /tmp/vwcd
tar xzf /tmp/vwcd/*.tar.gz

sudo vmware-tools-distrib/vmware-install.pl --force-install --default

# SSH keys
mkdir ~/.ssh
wget -nd https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
mv vagrant.pub ~/.ssh/authorized_keys

chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/authorized_keys

# then poweroff!
sudo poweroff