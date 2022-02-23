#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Prevent grub upgrades - RCC-VE devices use grub2, Minnowboards use grub-efi.
# On RCC-VE devices, grub still presents an interactive GUI complaining about
# the installation disk.
# On Minnowboards, grub also complains, though without a blocking GUI.
sudo apt-mark hold grub2 grub-efi || exit $?

sudo apt-get --allow-releaseinfo-change update || exit $?
sudo apt-get -q -y upgrade || exit $?
sudo apt-get -q -y install build-essential cmake git pkg-config || exit $?

# Seems to be necessary to get kernel update (maybe since we're blocking grub)
sudo apt-get -q -y dist-upgrade || exit $?
