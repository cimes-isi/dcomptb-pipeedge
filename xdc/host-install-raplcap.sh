#!/bin/bash
git clone https://github.com/powercap/raplcap.git || exit $?
mkdir raplcap/_build || exit $?
cd raplcap/_build || exit $?
git checkout v0.7.0 || exit $?
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo || exit $?
make -j || exit $?
sudo make install || exit $?
sudo ldconfig || exit $?
