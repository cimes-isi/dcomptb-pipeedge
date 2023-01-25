#!/bin/bash

# NOTE: This script is for reference - you probably shouldn't just execute it!
# There are too many assumptions built in to the scripts and the Ansible playbooks to list.
# Understand the Ansible playbooks and commands before running, and check outputs.


#
# Profile models in different power settings
#

# ViT at default power settings
ansible-playbook -i mb-0, rapl-configure-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-large-patch16-224 model_file={{ ansible_env.HOME }}/models/ViT-L_16-224.npz results_yml=profiler_results_vit_large.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-huge-patch14-224-in21k model_file={{ ansible_env.HOME }}/models/ViT-H_14.npz results_yml=profiler_results_vit_huge.yml" profile-pipeedge-model.yml

# ViT at 1.5 W
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=1.5" rapl-configure-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-1.5W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-large-patch16-224 model_file={{ ansible_env.HOME }}/models/ViT-L_16-224.npz results_yml=profiler_results_vit_large-1.5W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-huge-patch14-224-in21k model_file={{ ansible_env.HOME }}/models/ViT-H_14.npz results_yml=profiler_results_vit_huge-1.5W.yml" profile-pipeedge-model.yml

# ViT at 1.0 W
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=1.0" rapl-configure-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-1.0W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-large-patch16-224 model_file={{ ansible_env.HOME }}/models/ViT-L_16-224.npz results_yml=profiler_results_vit_large-1.0W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-huge-patch14-224-in21k model_file={{ ansible_env.HOME }}/models/ViT-H_14.npz results_yml=profiler_results_vit_huge-1.0W.yml" profile-pipeedge-model.yml

# ViT at 0.7 W
ansible-playbook -i mb-0, --extra-vars "enable=1 time_window_s=1 power_limit_w=0.7" rapl-configure-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-0.7W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-large-patch16-224 model_file={{ ansible_env.HOME }}/models/ViT-L_16-224.npz results_yml=profiler_results_vit_large-0.7W.yml" profile-pipeedge-model.yml
ansible-playbook -i mb-0, --extra-vars "model_name=google/vit-huge-patch14-224-in21k model_file={{ ansible_env.HOME }}/models/ViT-H_14.npz results_yml=profiler_results_vit_huge-0.7W.yml" profile-pipeedge-model.yml

# Reset power settings
ansible-playbook -i mb-0, rapl-configure-mb.yml


#
# Process profiler results into scheduler-compatible YAML files
#

# ViT at default power settings
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base.yml" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_large.yml" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_huge.yml" process-pipeedge-profiler-results-mb.yml

# ViT at 1.5 W
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-1.5W.yml process_model=False dev_type=MB-1.5W dev_type_mem=1024" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_large-1.5W.yml process_model=False dev_type=MB-1.5W dev_type_mem=1024" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_huge-1.5W.yml process_model=False dev_type=MB-1.5W dev_type_mem=1024" process-pipeedge-profiler-results-mb.yml

# ViT at 1.0 W
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-1.0W.yml process_model=False dev_type=MB-1.0W dev_type_mem=512" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_large-1.0W.yml process_model=False dev_type=MB-1.0W dev_type_mem=512" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_huge-1.0W.yml process_model=False dev_type=MB-1.0W dev_type_mem=512" process-pipeedge-profiler-results-mb.yml

# ViT at 0.7 W
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_base-0.7W.yml process_model=False dev_type=MB-0.7W dev_type_mem=256" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_large-0.7W.yml process_model=False dev_type=MB-0.7W dev_type_mem=256" process-pipeedge-profiler-results-mb.yml
ansible-playbook -i mb-0, --extra-vars "results_yml=profiler_results_vit_huge-0.7W.yml process_model=False dev_type=MB-0.7W dev_type_mem=256" process-pipeedge-profiler-results-mb.yml


#
# Collect and distribute scheduler-compatible YAML files
#

# Fetch scheduler YAML files from host
# WARNING: copies files into the current directory - will overwrite any existing files with the same names!
ansible mb-0 -m fetch -a "src=models.yml dest=./ flat=yes"
ansible mb-0 -m fetch -a "src=device_types.yml dest=./ flat=yes"

# Copy scheduler YAML files to hosts
ansible "mb-*" -m copy -a "src=models.yml dest=./"
ansible "mb-*" -m copy -a "src=device_types.yml dest=./"
