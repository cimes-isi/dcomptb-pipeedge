#!/bin/bash
sudo apt --allow-releaseinfo-change update || exit $?
sudo apt upgrade -y || exit $?
sudo apt install -y build-essential cmake pkg-config || exit $?
