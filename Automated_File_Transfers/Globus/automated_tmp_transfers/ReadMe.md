# Read Me
_This repository could be considered more about "coulda" and less about "shoulda"_
Transferring files to/from an individual compute node's local storage (i.e. /tmp) using Globus is a non-trivial task. The reason for this is because the endpoint that is configured for HPC is specifically for the storage array and so it does not "see" any of the compute nodes. When it is asked to look in /tmp, it will only ever look in the /tmp directory on the storage array. 

It is possible to connect to /tmp, but it requires some fancy footwork and I'm ultimately undecided on whether it's worth it. I will post my results below with the caution that I cannot guarantee the robustness of the techniques described. 

To do this:

Make sure you have the Globus CLI set up in your account. This can be pip installed into a python3 virtual environment, e.g.:
```
$ mkdir ~/Globus_virtual_Env
$ python3 virtualenv --system-site-packages ~/Globus_virtual_Env
$ source ~/Globus_virtual_Env/bin/activate
$ pip install globus-cli
```
Next, you will need globusconnectpersonal: https://www.globus.org/globus-connect-personal
```
$ cd ~
$ wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz
$ tar xzf globusconnectpersonal-latest.tgz
```

The configuration of globusconnectpersonal will be described below based on the number of jobs you're running


## Single job running on a single compute node
This is the easiest case because there isn't any crosstalk between individual personal endpoints. After following the preliminary steps above, go into globusconnectpersonal and configure an individual endpoint, e.g.:
```
$ cd globusconnectpersonal-3.0.4
$ globus endpoint create --personal my-linux-endpoint
```
This will generate an endpoint and setup ID. Save these somewhere. Then:
```
$ ./globusconnectpersonal -setup <saved setup key>
```
Lastly, you'll need to change the contents of a file. You can make a backup of the file just in case. Change the contents of ~/.globusonline/lta/config-paths to ```/tmp,0,1```

if this step doesn't happen, then trying to access /tmp with globus will throw a permissions error.

Once that's all configured, you can start a local session using 
```
./globusconnectpersonal -start &
```
And then use that endpoint's ID to make transfers as you normally would. 


## Running multiple jobs
There are a lot of technical problems that arise when trying to automate transfers to/from /tmp when more than one job is running at a time:

1. When using the default options of globusconnectpersonal, only one endpoint ID can be active at a time. This means that running multiple jobs and trying to open a new connection for each fails.

You can get around this by configuring a separate globus config directory for each endpoint and then point Globus to that config directory when activating the endpoint. This works in the case when jobs are all on distinct compute nodes.

2. In the case where two or more jobs wind up on the same compute node, more than one session is not allowed, even if globusconnectpersonal is being pointed to different config directories. You can get around this by having a job use the endpoint that has already been activated on that compute node.

3. In the case that you use an endpoint that is already activated on a compute node, if the preexisting job that created the endpoint ends before the later job has completed its transfer, that later transfer will fail. This is because the endpoint will go offline while the job is waiting for the transfer to complete and it will just sit there until the job's walltime is hit. 

General overview of the solution:

1. Make sure you have the Globus cli configured in your account
2. Get GlobusConnectPersonal
3. Configure an endpoint for each job that needs to be run. E.g., if you're going to run 5 jobs, you'll need 5 separate endpoints. Don't go overboard with this. If you're running thousands of jobs, a different workflow is needed, e.g. moving your data to/from a staging area like /xdisk, /groups, or /home. If you're moving data off HPC, consider archiving and then transferring the single archive from there after your jobs complete.
3. Use an external file to keep track of which endpoints are in use and where their config files can be found. 

