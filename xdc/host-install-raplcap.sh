#!/bin/bash
git clone -q https://github.com/powercap/raplcap.git || exit $?
mkdir raplcap/_build || exit $?
cd raplcap/_build || exit $?
git checkout -q v0.7.0 || exit $?
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo || exit $?
make -j || exit $?
sudo make -j install || exit $?
sudo ldconfig || exit $?
