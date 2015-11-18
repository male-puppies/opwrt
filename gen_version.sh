#!/usr/bin/env bash

#executes this file before "make V=s"

VERSION_TMP_FILE="bin/opwrt_custome.version"
CFG_VERSION_VAR_NAME="CONFIG_VERSION_NUMBER"
CFG_VERSION_FILE=".config"
	
usage() {
	cat <<EOF
Usage: $0 [options] <command> [arguments]
Commands:
	help              			This help text
	set <target> <subtarget>    set target name and subtarget
	
Options:

EOF
	exit ${1:-1}
}

version_set() {
	local target="$1"
	local subtarget="$2"
	echo "target:"$target
	echo "subtarget:"$subtarget
	cfg_version_number=`cat .config | grep $CFG_VERSION_VAR_NAME`
	echo "[cur_version]:"$cfg_version_number

	TIME_STAMP="`date +%y%m%d%H%M%S`"
	echo "[time_stamp]:"$TIME_STAMP
	n_cfg_version_number="$CFG_VERSION_VAR_NAME=\"$TIME_STAMP\""
	echo "[new_version]:"$n_cfg_version_number

	cfg_version_number=${cfg_version_number//\"/\\\"}
	n_cfg_version_number=${n_cfg_version_number//\"/\\\"}
	echo "s/$cfg_version_number/$n_cfg_version_number/g"
	sed -i 's/'$cfg_version_number'/'$n_cfg_version_number'/g' .config
	echo "changing $cfg_version_number to $n_cfg_version_number"

	echo $TIME_STAMP > $VERSION_TMP_FILE
	echo "del old openwrt_version & openwrt_release"

	rm "build_dir/target-mips_34kc_musl-1.1.11/linux-${target}_${subtarget}/base-files/ipkg-ar71xx/base-files/etc/openwrt_version"
	rm "build_dir/target-mips_34kc_musl-1.1.11/linux-${target}_${subtarget}/base-files/ipkg-ar71xx/base-files/etc/openwrt_release"
	rm "build_dir/target-mips_34kc_musl-1.1.11/root-${target}/etc/openwrt_version"
	rm "build_dir/target-mips_34kc_musl-1.1.11/root-${target}/etc/openwrt_release"
	rm "staging_dir/target-mips_34kc_musl-1.1.11/root-${target}/etc/openwrt_version"
	rm "staging_dir/target-mips_34kc_musl-1.1.11/root-${target}/etc/openwrt_release"
}

COMMAND="$1"; shift
case "$COMMAND" in
	help) usage 0;;
	set) version_set "$@";;
	*) usage;;
esac






