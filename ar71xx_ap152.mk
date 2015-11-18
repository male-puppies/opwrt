#!/usr/bin/env bash
./gen_version.sh set ar71xx generic
make V=s
./version_file.sh set ar71xx ap152


