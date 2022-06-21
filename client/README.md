# Client Scripts

## MergeTB Access

You must must have an account on [MergeTB](https://launch.mergetb.net/) with access to the [Distributed Computing Testbed](https://www.dcomptb.net/).

Download `mergetb` (not `mergexp`) as linked from the [MergeTB docs](https://www.mergetb.org/docs/cli).
Then login, substituting your user name for `<username>`:

```sh
mergetb login <username>
```

## Configure SSH

We recommend generating a new SSH key for use with MergeTB in case you want to upload the private key to the XDC later (e.g., if you don't want to use SSH authentication forwarding).
The exact command to generate SSH keys depends on your client operating system.
For example, to generate a key called `id_rsa_mergetb` on Linux (on macOS, consider adding the `--apple-use-keychain` option):

```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_mergetb -C "foo@bar.com"
```

The `-C <comment>` option is useful if you intended to work with `git` on the testbed (substitute with your own email address), but it is optional.
You will be prompted for a passphrase - the [MergeTB docs](https://www.mergetb.org/docs/web/#add-your-public-key) recommend using a passphrase, but this is also optional (we do not).

Now add your public key MergeTB:

```sh
mergetb pubkey ~/.ssh/id_rsa_mergetb.pub
```

Add the key to your local SSH authentication agent to be used for authentication forwarding:

```sh
ssh-add ~/.ssh/id_rsa_mergetb
```


## Experiment Setup

Create an experiment, realize it, then materialize it.
For example, create an experiment called `pipeedge` using the specified `mergexp` Python source file, then a realization called `realization1`:

```sh
mergetb new exp pipeedge --src ../models/8-MB-8-RCC.py
mergetb realize pipeedge realization1 --accept
mergetb materialize pipeedge realization1
mergetb wait materialize pipeedge realization1
```

Note: Waiting for materialization may take several minutes.

Now create an Experiment Development Container (XDC) called `xdc1`:

```sh
mergetb new xdc pipeedge xdc1
```


## SSH to the XDC

If you are using Ubuntu Linux, see the [MergeTB docs on XDC Access](https://www.mergetb.org/docs/xdc-access) (probably not an issue if your Ubuntu version is >= 18.04 LTS (Bionic Beaver)).

Otherwise, to SSH to the XDC, substitute your personal project name (probably the same as your MergeTB username) for `<project>`:

```sh
ssh -i ~/.ssh/id_rsa_mergetb -A -J jumpc.mergetb.io:2202 xdc1-pipeedge-<project>
```

Optional: Upload the private key to the XDC (we recommended creating a unique SSH key specifically for this):

```sh
scp -i ~/.ssh/id_rsa_mergetb -o ProxyJump=jumpc.mergetb.io:2202 ~/.ssh/id_rsa_mergetb xdc1-pipeedge-<project>:.ssh/id_rsa
```

You can then drop the `-A` option when connecting to the XDC with `ssh`.


## Experiment Teardown

Free resources:

```sh
mergetb delete xdc pipeedge xdc1
mergetb dematerialize pipeedge realization1
mergetb wait dematerialize pipeedge realization1
mergetb free pipeedge realization1
# wait may not be needed - you may safely ignore "Not Found" / 404 errors
mergetb wait free pipeedge realization1
mergetb delete experiment pipeedge
```

Note: Waiting for dematerialization may take several minutes.
