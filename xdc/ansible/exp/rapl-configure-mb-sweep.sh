#!/bin/bash

# NOTE: This script is for reference - it does nothing on its own except change power caps.
# You probably want to execute the individual line for the power cap you're interested in, then
# separately do whatever you care about (e.g., profiling), then finally reset the power cap.

# RAPL on Minnowboards must ENABLE CORE and CONFIGURE PACKAGE with time window and power limit.

# Sweep configuration space
# Polling RAPL shows it maxes at around 2.5 W
ansible-playbook -i mb-0, rapl-configure-mb.yml # 0.6 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=4" rapl-configure-mb.yml # 0.6 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=3" rapl-configure-mb.yml # 0.6 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=2.5" rapl-configure-mb.yml # 0.59 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=2" rapl-configure-mb.yml # 0.5 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=1.5" rapl-configure-mb.yml # 0.41 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=1" rapl-configure-mb.yml # 0.28 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=0.7" rapl-configure-mb.yml # 0.18 tensors/sec
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=0.5" rapl-configure-mb.yml # 0.17 tensors/sec

# Reset
ansible-playbook -i mb-0, --extra-vars "enable=0" rapl-configure-mb.yml
