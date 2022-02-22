#!/bin/bash
git clone -q https://github.com/energymon/energymon.git || exit $?
mkdir energymon/_build || exit $?
cd energymon/_build || exit $?
# TODO: use v0.5.0 once released w/ jetson support (for consistency w/ CHI@Edge)
git checkout -q v0.4.0 || exit $?
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENERGYMON_BUILD_DEFAULT=energymon-raplcap-msr || exit $?
make -j || exit $?
sudo make install || exit $?
sudo ldconfig || exit $?
