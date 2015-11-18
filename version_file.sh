#!/usr/bin/env bash

#executes this file after "make V=s"
VERSION_TMP_FILE="bin/opwrt_custome.version"
PLATFORM="ar71xx"

usage() {
	cat <<EOF
Usage: $0 [options] <command> [arguments]
Commands:
	help              			This help text
	set <platform> <devname>    set platform name and devname
	
Options:

EOF
	exit ${1:-1}
}


get_upgrade_version() {
	if [ -e $VERSION_TMP_FILE ];then
		local version=`cat $VERSION_TMP_FILE`
		if [ -n "$version" ];then
			echo "$version"
		fi
	fi
	echo ""
}


platform_set() {
	local platform="$1"
	local dev="$2"
	echo "[platform]":$platform
	local plat_dir="bin/$platform"
	if ! [ -d "$plat_dir" ]; then
		echo "$plat_dir not a directory"
		return
	fi
	echo "del bin/$dev.*"
	del_file="bin/$dev.*"
	rm $del_file	
	local upgrade=$(get_upgrade_version) #call function
	if ! [ -n "$upgrade" ];then
		echo "invalid upgrade version"
		return 
	fi
	echo "[upgrade_version]:$upgrade"
	
	local upgrade_name=`ls bin/ar71xx/ | grep upgrade | grep $upgrade`
	if ! [ -n "$upgrade_name" ];then
		echo "file name with \"$upgrade\" is not existence."
		return
	fi
	echo "[upgrade_bin]:$upgrade_name"
	local src_firmare="$plat_dir/$upgrade_name"
	local dst_firmware="bin/$dev.$upgrade" 
	cp -f $src_firmare $dst_firmware

	local version_name="bin/$dev.version"
	local md5sum=`md5sum $dst_firmware | awk '{print $1}'`
	echo $dst_firmware
	echo "$dev.$upgrade" >$version_name
	echo $md5sum
	echo $md5sum >> $version_name
	echo "create $version_name success"
	echo "create $dst_firmware sucess"
}

COMMAND="$1"; shift
case "$COMMAND" in
	help) usage 0;;
	set) platform_set "$@";;
	*) usage;;
esac
