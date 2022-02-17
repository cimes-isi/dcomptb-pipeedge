#!/bin/bash
sudo apt install -y "linux-headers-$(uname -r)" || exit $?
git clone https://github.com/LLNL/msr-safe.git || exit $?
cd msr-safe || exit $?
git checkout v1.6.0 || exit $?
make || exit $?
