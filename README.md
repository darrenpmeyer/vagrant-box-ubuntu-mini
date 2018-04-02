# vagrant-box-ubuntu-mini

A Vagrant Box for VMWare that's the most recent LTS Ubuntu Mini, with nothing added except open-vm-tools

Currently **Ubuntu 16.04 Xenial Xerus (64-bit)**

# Using the box

This box is ~1GB, and is intended as a base to build on. It's hosted on HashiCorp's Vagrant Cloud service

You can do

	vagrant init darrenpmeyer/ubuntu-xenial64-mini
	vagrant up

Or you can specify a `Vagrantfile` with content including:

	Vagrant.configure("2") do |config|
	  config.vm.box = "darrenpmeyer/ubuntu-xenial64-mini"
	  config.vm.box_version = "0.2.0"
	end

The [Vagrant Cloud entry](https://app.vagrantup.com/darrenpmeyer/boxes/ubuntu-xenial64-mini) has more details

# Using this repo to build your own base box

1. Download an [Ubuntu minimal CD ISO](https://help.ubuntu.com/community/Installation/MinimalCD)
2. Create a virtual machine (we assume VMWare Fusion as a host from here on; adapt as you need) and install Ubuntu into it:
	1. You _must_ include OpenSSH server during package selection
	2. You _should_ set up the user `vagrant` with a password of `vagrant`; further instructions assume you've done this
	3. You _should_ set the RAM relatively low; consumers can increase it easily if needed
3. Provision the box
	1. Apply `sshd_config.patch` and `sudoers.patch` from the `provision` directory to the guest's `/etc/ssh/sshd_config` and `/etc/sudoers`, respectively. You'll need to use `sudo` to do this.
	2. Copy the contents of `vagrant.pub` from the `provision` directory to the `vagrant` user's `~/.ssh/authorized_keys` file
	3. `chmod 0700 ~/.ssh ; chmod 0600 ~/.ssh/authorized_keys`
	4. `sudo apt-get install open-vm-tools`
	5. Shutdown (e.g. `sudo poweroff`)
4. If you're not using the `vmware_fusion` provider, change the `metadata.json` file appropriately. Copy `metadata.json` to the `.vmwarevm` directory for your new box. It needs to be UTF8 _without BOM_; you can use the `encode_metadata.py` script to encode it properly. 
5. Run `./vmware-clean.sh package /path/to/youre/vmware_machine.vmwarevm` -- this will defrag and shrink the VM disks then create the `.box` file. (VMWare Fusion only! Figure out the equivalent for your provider if needed)
6. Upload the box somewhere, like Vagrant Cloud

## More on `vmware-clean.sh`

    ./vmware-clean.sh [package [noshrink]] /path/to/vmware-box.vmwarevm

Without any optional args, will shrink `Virtual Disk.vmdk` and it's associated `.vmdk` fragments by defraging and reclaiming space. If you want to shrink a different `.vmdk`, you can provide the full path to it instead of the path to the `.vmwarevm`. For example, if I named my disk `TheDisk.vmdk`, I might use:

	./vmware-clean.sh /path/to/vmware-box.vmwarevm/TheDisk.vmdk

If you use the `package` option, a box will be created based on the name of the VM guest directory; for example:

	./vmware-clean.sh package /path/to/vmware-box.vmwarevm

would create `vmware-box.box` in the working directory. By default, using `package` will perform the shrink _and_ then make the package. If you already shrunk the disks or wish not to for some horrible reason, you can specify `noshrink`:

	./vmware-clean.sh package noshrink /path/to/vmware-box.vmwarevm

would skip the disk defrag and shrink phases and simply make the `vmware-box.box` file.
