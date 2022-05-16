# DCompTB Experiment Scripts for EdgePipe

## Configure the Experiment Development Container (XDC)

Login and attach to the experiment realization, substituting your username and project name (by default, `<project>` is the same as your `<username>`):

```sh
xdc login <username>
xdc attach <project> edgepipe realization1
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
sudo apt-get install -y git
```

Fetch this repository and change to its `xdc/ansible/` directory:

```sh
git clone https://github.com/cimes-isi/dcomptb-edgepipe.git
cd dcomptb-edgepipe/xdc/ansible/
```


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

Now install custom dependencies (NOTE: there is a partial ordering for these scripts, e.g., `energymon` depends on `raplcap`, `edgepipe` depends on `cnpy`):

```sh
ansible-playbook install-msr-safe.yml
ansible-playbook install-raplcap.yml
ansible-playbook install-energymon.yml
ansible-playbook install-edgepipe.yml
ansible-playbook install-edgepipe-models.yml
```

Note: When installing EdgePipe, the task "Copy models from controller to hosts" may be slow, which increases the chances of the SSH connection being interrupted/reset (Ansible fails with "unreachable" status for host).
If this occurs, ensure the failed host is still alive and re-run the script until it is successful.


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

Test a distributed EdgePipe execution (should take about 2 minutes):

```sh
ansible-playbook exp/test-2-nodes.yml --extra-vars "fail_if_test_dir_exists=false"
```
