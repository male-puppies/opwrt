#!/usr/bin/env bash

#executes this file before "make V=s"
VERSION_TMP_FILE="bin/opwrt_custome.version"
CFG_VERSION_VAR_NAME="CONFIG_VERSION_NUMBER"
CFG_VERSION_FILE=".config"
CFG_VERSION_NUMBER=`cat .config | grep $CFG_VERSION_VAR_NAME`
echo "[cur_version]:"$CFG_VERSION_NUMBER

TIME_STAMP="`date +%y%m%d%H%M%S`"
echo "[time_stamp]:"$TIME_STAMP
N_CFG_VERSION_NUMBER="$CFG_VERSION_VAR_NAME=\"$TIME_STAMP\""
echo "[new_version]:"$N_CFG_VERSION_NUMBER

CFG_VERSION_NUMBER=${CFG_VERSION_NUMBER//\"/\\\"}
N_CFG_VERSION_NUMBER=${N_CFG_VERSION_NUMBER//\"/\\\"}
echo "s/$CFG_VERSION_NUMBER/$N_CFG_VERSION_NUMBER/g"
sed -i 's/'$CFG_VERSION_NUMBER'/'$N_CFG_VERSION_NUMBER'/g' .config
echo "changing $CFG_VERSION_NUMBER to $N_CFG_VERSION_NUMBER"

echo $TIME_STAMP > $VERSION_TMP_FILE



