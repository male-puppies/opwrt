#!/usr/bin/env bash

#executes this file after "make V=s"
VERSION_TMP_FILE="bin/opwrt_custome.version"
PLATFORM="ar71xx"

usage() {
	cat <<EOF
Usage: $0 [options] <command> [arguments]
Commands:
	help              This help text
	platform <name>   set platform name
	
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
	echo "[platform]":$platform
	local plat_dir="bin/$platform"
	if ! [ -d "$plat_dir" ]; then
		echo "$plat_dir not a directory"
		return
	fi
	
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
	local version_name="$upgrade_name.version"
	local md5sum=`md5sum $plat_dir/$upgrade_name | awk '{print $1}'`
	echo $upgrade_name
	echo $upgrade_name > bin/$version_name
	echo $md5sum
	echo $md5sum >> bin/$version_name
	echo "create bin/$version_name success"
}

COMMAND="$1"; shift
case "$COMMAND" in
	help) usage 0;;
	platform) platform_set "$@";;
	*) usage;;
esac
