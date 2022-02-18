#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get --allow-releaseinfo-change update || exit $?
sudo apt-get -q -y upgrade || exit $?
sudo apt-get -q -y install build-essential cmake git pkg-config || exit $?
