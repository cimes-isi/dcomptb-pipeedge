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


## Install XDC Dependencies

Install package dependencies:

```sh
sudo apt install -y git pssh
```

Fetch this repository and change to its `xdc` directory:

```sh
git clone https://github.com/cimes-isi/dcomptb-edgepipe.git
cd dcomptb-edgepipe/xdc/
````

Create a `hosts.txt` file with the hostnames in the experiment.
For example, you can parse from the inventory:

```sh
xdc ansible inventory | awk '/\[/{prefix=$0; next} $1{print prefix $0}' | grep "\[all\]" | cut -d']' -f2 > hosts.txt
```

Then test that you can execute commands on hosts in the experiment:

```sh
parallel-ssh -h hosts.txt -i hostname
```


## Install Worker Dependencies

Install system package dependencies:

TODO: This fails b/c it hangs on Grub on RCC-VE devices - can we ignore grub-pc/grub2?

```sh
parallel-ssh -h hosts.txt -i -t 1200 -I < ./host-install-packages.sh
```

Note: Installing packages may take several minutes.
If apt/dpkg have problems, fix them manually before proceeding.
The above command may be safely re-run.

Now reboot the devices to load newer kernels for which headers are actually available:

```sh
parallel-ssh -h hosts.txt sudo reboot
```

Ignore any "Exited with error code 255" messages.
Wait a few minutes until you can ping all devices successfully:

```sh
xdc ansible ping
```

Now install custom dependencies (NOTE: there is a partial ordering for these scripts, e.g., `energymon` depends on `raplcap`):

```sh
parallel-ssh -h hosts.txt -i -t 300 -I < ./host-install-msr-safe.sh
parallel-ssh -h hosts.txt -i -t 300 -I < ./host-install-raplcap.sh
parallel-ssh -h hosts.txt -i -t 300 -I < ./host-install-energymon.sh
```

## Initialize Worker Environment

These scripts initialize the environment and must be re-run if hosts are rebooted.
It is safe to re-run them as long as the dependencies above are complete.

Load the `msr-safe` kernel module:
```sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./host-load-msr-safe.sh
```

### Smoke Test(s)

Test that RAPL energy monitoring is working properly:

```sh
parallel-ssh -h hosts.txt -P rapl-configure-msr
```
