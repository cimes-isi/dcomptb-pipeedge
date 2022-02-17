# DCompTB Experiment Scripts for EdgePipe

## XDC

First, the XDC must be configured to drive experiments.

Configure `~/.ssh/known_hosts` with:

```sh
ANSIBLE_HOST_KEY_CHECKING=False xdc ansible ping
```

Install dependencies:

```sh
apt install -y pssh git
```

Create a `hosts.txt` file with the hostnames for the hosts in the experiment.
Then test it out:

```sh
parallel-ssh -h hosts.txt -i hostname
```

## Software Dependencies

Dependencies only need to be installed once.

Install system package dependencies:

```sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./host-install-packages.sh
```

If apt/dpkg have problems, fix them manually before proceeding.
The above command may be safely re-run.

Now install custom dependencies (NOTE: there is a partial ordering to these scripts, e.g., `energymon` depends on `raplcap`):

```sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./host-install-msr-safe.sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./host-install-raplcap.sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./host-install-energymon.sh
```

## Initialize Environment

These scripts initialize the environment and must be re-run if hosts are rebooted.
It is safe to re-run them as long as the dependencies above are complete.

Load the `msr-safe` kernel module:
```sh
parallel-ssh -h hosts.txt -P -t 1200 -I < ./msr-safe-load.sh
```

### Smoke Test(s)

Test that RAPL energy monitoring is working properly:

```sh
parallel-ssh -h hosts.txt -P rapl-configure-msr
```
