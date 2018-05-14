#!/usr/bin/env bash
vmware_root="/Applications"
vdiskmanager="${vmware_root}/VMware Fusion.app/Contents/Library/vmware-vdiskmanager"

package=false
shrink=true

if [[ "$1" == "package" ]]
then
	package=true
	shift

	if [[ "$1" == "noshrink" ]]
	then
		shrink=false
		shift
	fi
fi

vmdk="$1"
vmdir=$(dirname "$vmdk")
if [[ -d "$vmdk" ]]
then
	vmdir="$vmdk"
	vmdk="$vmdir/Virtual Disk.vmdk"
fi

if ! [[ -f "$vmdk" ]]
then
	echo "Sorry, '$vmdk' isn't a file"
	exit 127
fi

vmdkbase=$(basename "$vmdk")
echo "Working with '$vmdkbase' in '$vmdir'"

if [[ $shrink == true ]]
then
	echo "$shrink"
	"$vdiskmanager" -d "$vmdk"
	"$vdiskmanager" -k "$vmdk"
else
	echo "Skipping defrag/shrink"
fi

if [[ $package == true ]]
then
	basefilename=$(basename "$vmdir")
	basefilename=${basefilename/%.vmwarevm/}
	boxfile="$basefilename.box"
	echo "Packing '$boxfile'"

	wd=$(pwd)
	cd "$vmdir"
        echo "Removing unneeded files"
        rm *.log
        rm -rf caches
        rm -rf *.lck

        mixins="$wd/provision/boxfile"
        if [[ -d "$mixins" ]]
        then
            echo "Adding boxfile mixins from '$mixins'"
            cp -pv "$mixins"/* .
        fi
            

	echo "Compressing image to '$boxfile'"
        tar czvf "$wd/$boxfile" ./*

	cd "$wd"
fi
