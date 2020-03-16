# Automating Globus Transfers



## Setting up the Globus-CLI

There are two ways to set up the Globus CLI for personal use on HPC. The first is using a global version that is available on the DTN. The second is installing a personal version for use in your home account. The setup process for both is very similar with a few extra steps needed to install the personal version.

### System Globus CLI on DTN

To use the system-wide Globus installed on the DTN, you'll just needs to log in using:

```
$ ssh sdmz-dtn-3.hpc.arizona.edu
$ which globus
/usr/local/bin/globus
```

When using this version, Globus commands may only be executed on this node and cannot be used directly from your account on hpc (i.e. after logging in with ```ssh <netid>@hpc.arizona.edu```). However, there are still ways to incorporate file transfers into your workflow. Demonstrations will be available soon.

### Personal Globus CLI in User's Account

To set up a local version of Globus, you will need to create and activate a virtual environment. The Globus CLI is available as a package that can be pip installed using python 3. 

To set up a virtual environment on Ocelote:

```
$ mkdir ~/my_globus_environment
$ module load python/3.6/3.6.5
$ virtualenv --system-site-packages ~/my_globus_environment
$ source ~/my_globus_environment/bin/activate
```

For more information on setting up python virtual environments, we have instructions [in our online documentation](https://public.confluence.arizona.edu/display/UAHPC/Using+and+Installing+Python)

Once your virtual environment is activated, you may install Globus using:

```
$ pip install globus-cli
...
$ which globus
~/my_globus_environment/bin/globus
```

Each time you want to use globus in your personal account, you will need to activate the virtual environment. If desired, you may add an activate command (e.g. ```source ~/my_globus_environment/bin/activate```) to your .bashrc file so this is done automatically each time you log in.

### Setup

This will be the same regardless of which version of Globus you're using. The only difference is where this setup is run. If you are using the system version, you will need to log into the DTN to perform the set up. If you are using a local installation, you may do this in your HPC account. Your python virtual environment will need to be activate prior to setup. 

To set up the software for use:

```
$ globus login --no-local-server 
Please authenticate with Globus here:
------------------------------------
<long URL>
------------------------------------

Enter the resulting Authorization Code here:
```

Copy the long URL that is printed to the terminal and paste it into an internet browser. This will redirect you to Globus where you will log in with your user information. If you have never used Globus before, you may refer [to our online documentation on setting up your university account](https://public.confluence.arizona.edu/display/UAHPC/Transferring+Files#TransferringFiles-GridFTP/Globus). 

After you successully log in through the browser, you will be given an authorization code. Copy and paste this into your terminal to complete the setup. To ensure that the setup has gone correctly and that you have successully logged in, you may use the command: 

```
(my_globus_environment) [sarawillis@login2 ~]$ globus whoami
For information on which identities are in session see
  globus session show

sarawillis@arizona.edu
```

Once you have set everything up, you will remain logged in and will not have to repeat the process to use the software.


## Making Transfers

For information on making transfers with Globus, there are guides in their documentation that will walk you through the process: https://docs.globus.org/cli/quickstart/

Transfers that are initiated through the CLI may be monitored via the Globus web portal. 

This repository currently contains a single bash script that is used as an example of how to integrate file transfers in a user's workflow. The goal is for this repository to grow as I continue to help users with their transfer needs. A benchmarking script is currently available (used to test Globus transfers speeds) [in another of my github repositories](https://github.com/SaraMWillis/Cloud_Storage_Benchmarking/tree/master/AWS_S3/BenchmarkingScripts). This script is written in python and may be modified to create a script for automating file transfers. It is likely I will do this in the near future.

