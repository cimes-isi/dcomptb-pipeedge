#!/bin/bash
if [ -e /dev/cpu/msr_allowlist ]; then
  echo "msr-safe already loaded"
  exit 0
fi
sudo insmod msr-safe/msr-safe.ko || exit $?
NPROC=$(nproc)
for (( i=0; i<NPROC; i++ )); do
  sudo chmod go+rw "/dev/cpu/${i}/msr_safe" || exit $?
done
cat raplcap/msr/etc/msr_safe_allowlist | sudo tee -a /dev/cpu/msr_allowlist > /dev/null
