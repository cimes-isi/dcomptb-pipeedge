# DCompTB Experiment Scripts for PipeEdge

## Configure the Experiment Development Container (XDC)

Login and attach to the experiment realization, substituting your username and project name (by default, `<project>` is the same as your `<username>`):

```sh
xdc login <username>
xdc attach <project> pipeedge realization1
```

Configure `~/.ssh/known_hosts` with:

```sh
ANSIBLE_HOST_KEY_CHECKING=False xdc ansible ping
```

Note: if you receive an error like "Cannot write to ControlPath", fix some file and directory ownerships and try again (an apparent bug in `xdc` because it has setuid as root):

```sh
sudo chown $USER:$USER ~/.ssh/known_hosts
sudo chown -R $USER:$USER ~/.ansible
ANSIBLE_HOST_KEY_CHECKING=False xdc ansible ping
```

Configure the ansible inventory and test that you can execute commands on the hosts in the experiment (by having them print their hostnames):

```sh
sudo cp /etc/ansible/hosts /etc/ansible/hosts.orig
xdc ansible inventory | sudo tee -a /etc/ansible/hosts > /dev/null
ansible all -a hostname
```

Install XDC package dependencies:

```sh
sudo apt-get update
sudo apt-get install -y git
```

If `apt-get update` prints a GPG error for mergetb repositories, you can safely ignore the message -- this repository is only used for the `mergetb` package, and no updates are expected for it.
However, if it bothers you, get the latest GPG key and retry:

```sh
curl -L https://pkg.mergetb.net/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/mergetb.gpg add -
sudo apt-get update
```

Fetch this repository and change to its `xdc/ansible/` directory:

```sh
git clone https://github.com/cimes-isi/dcomptb-pipeedge.git
cd dcomptb-pipeedge/xdc/ansible/
```


## Download and Deploy Models

To fetch models, we need a copy of PipeEdge on the XDC, although it won't be used in pipelines.
Fetching models sometimes requires loading them, and some are too big to load in their entirety on some worker nodes (hence the need for PipeEdge):

```sh
ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 install-pipeedge.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 fetch-pipeedge-models.yml
```

Now deploy models to workers (one worker at a time to try and reduce connection timeouts and network thrashing):

```sh
ansible-playbook -f 1 deploy-pipeedge-models.yml
```

Note: Ansible often fails with "unreachable" status for host when deploying models.
If this occurs, ensure the failed host is still alive and re-run the script as-needed.


## Install Worker Dependencies

Update package dependencies:

```sh
ansible-playbook apt-upgrade.yml
```

Devices may reboot as part of the upgrade.
If this is your initial setup and the task "Reboot if required" is skipped, then manually direct the workers to reboot (this is necessary to get a kernel for which headers are available):

```sh
ansible all -b -m reboot
```

Now install custom dependencies (NOTE: there is a partial ordering for these scripts, e.g., `energymon` depends on `raplcap`):

```sh
ansible-playbook install-msr-safe.yml
ansible-playbook install-raplcap.yml
ansible-playbook install-energymon.yml
ansible-playbook install-pipeedge.yml
```


## Initialize Worker Environment

These scripts initialize the environment and must be re-run if hosts are rebooted.
It is safe to re-run them as long as the dependencies above are complete.

Load the `msr-safe` kernel module:

```sh
ansible-playbook load-msr-safe.yml
```

### Smoke Test(s)

Test that RAPL energy monitoring is working properly:

```sh
ansible all -a rapl-configure-msr
```

Test a distributed PipeEdge execution (should take about 2 minutes):

```sh
ansible-playbook exp/test-2-nodes.yml --extra-vars "fail_if_test_dir_exists=false"
```


## Device Model Profiling

NOTE: Our _realization_ uses name format `mb-X` for Minnowboard devices and `rcc-X` for RCC-VE devices, where `X >= 0`.

The [exp/profile-pipeedge-model.yml](./ansible/exp/profile-pipeedge-model.yml) playbook demonstrates profiling the ViT-Base model, but also exposes variables so it can be used for other models (e.g., to specify the model name, model weights file, and results YAML file).
Additionally, profiling only needs to be run on a single host of each device type (e.g., only a single Minnowboard or a single RCC-VE device).

Profiling results need to be processed into scheduler-compatible YAML files before PipeEdge can use them.
The [exp/process-pipeedge-profiler-results-mb.yml](./ansible/exp/process-pipeedge-profiler-results-mb.yml) playbook performs these steps, and is also configurable using variables.

For a _reference_ example in using these playbooks, see the [exp/profile-pipeedge-models-mb.sh](./ansible/exp/profile-pipeedge-models-mb.sh) shell script.
This script profiles three ViT models on a Minnowboard device `mb-0` under different RAPL power caps, processes them, collects the scheduler-compatible YAML files, then deploys those files to all Minnowboard hosts.
