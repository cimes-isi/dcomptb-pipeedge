# Distributed Computing Testbed - PipeEdge Scripts

This repository contains documentation and scripts for running [PipeEdge](https://github.com/usc-isi/PipeEdge) experiments on the [Distributed Computing Testbed](https://www.dcomptb.net/).

Directory structure:

* client: Documentation and scripts to run from the client system (e.g., your laptop or desktop)
* models: MergeTB experiment models
* xdc: Documentation and scripts to run from an Experiment Development Container (XDC)

Login at: https://launch.mergetb.net/

Support channel: https://chat.mergetb.net/mergetb/channels/dcomptb


## Instructions

Start with the instructions in the `client` directory to configure your local system and create an experiment on the testbed.
After your testbed *experiment* is *realized* and then *materialized*, you can SSH to the *experiment development container* (XDC) created on the testbed.

From your XDC SSH session, follow the instructions in the `xdc` directory.
These directions configure your XDC to use your experiment realization, then use Ansible scripts to setup software on the evaluation Minnowboard and RCC-VE platforms.
