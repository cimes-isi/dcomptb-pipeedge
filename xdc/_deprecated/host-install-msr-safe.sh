#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -q -y "linux-headers-$(uname -r)" || exit $?
git clone -q https://github.com/LLNL/msr-safe.git || exit $?
cd msr-safe || exit $?
git checkout -q v1.6.0 || exit $?
make || exit $?
