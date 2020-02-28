# Read Me

_This repository is still a work in progress and may have half-finished thoughts/poor documentation/inconsistencies. I'm working on cleaning this up_

## About
Figuring out effective ways to submit large numbers of jobs can be frustrating. This repository is designed to try to help implement different techniques to run jobs as arrays/in parallel. They are written for submission with PBS scheduling software on University of Arizona's HPC. 

As a note, these scripts have typically been written in response to submitted user questions and as such may have some idiosynchracies that are specific to each case (I'm working to iron them out to make each example more uniform). Each script is designed to print commands and information specific to that job for better visualization/demonstration purposes. 

HPC users should be able to run each script with minor modifications (i.e. adding their PI's group name) to experiment.


### What are some problems that arise when submitting lots of jobs?

Common things that can wreak havoc on HPC are submissions that overload our scheduling software. This typically boils down to two things:

1. Submitting individual jobs with for loops    -- Too many jobs/Jobs submitted too quickly
2. Submitting a tremendous number of array jobs -- Too many jobs for the scheduler to keep track of

This can lead to low/nonexistent system performance and unhappy users. This is designed to be an expanding repo of techniques that will run jobs more efficiently without putting as much stress on the system. 




# Scripts

**Script Names are presented in order of type and increasing complexity as opposed to alphabetically**

## Array Jobs

To submit an array job with PBS, use the command:

```
#PBS -J N-M
```
This tells PBS the number of jobs you want to run with this script and the range of the indices, from ```N``` to ```M``` inclusive, where ```N``` and ```M``` are integers. So, for example, if you wanted to run four jobs, you could use ```#PBS -J 1-4```, ```#PBS -J 5-8```, etc... 

You may submit your job with a single command:

```
$ qsub <script_name>.pbs
```

and you will be returned a single job ID of the form: ```<job_number>[]```. PBS will schedule as many jobs for you as indices you've requested with associated subjob IDs of the form ```<job_number>[<array_index>]```. More explicitly:

```
Overall Job ID : <job_number>[] # the [] indicates it's an array
Job 1          : <job_number>[1]
Job 2          : <job_number>[2]
Job 3          : <job_number>[3]
...
```


### Basic_Array_Job

#### Problem

A user wants to submit multiple jobs using the same script with different input.

#### Solution

Using an array job can run multiple tasks and differentiate them using array indices. The tasks are run using only one ```qsub``` command.


### Sample_Array_Read_Filenames


#### Problem

A user wants to run multiple jobs where each opens a different file to analyze but the naming scheme isn't conducive to automating the process using simple array indices as shown in Basic_Array_Job (i.e. 1.txt, 2.txt, ...).

#### Solution

The user can create an input file with one filename per line. One filename is read in per array job using array indices. 

### Sample_Array_Input_Parameters

#### Problem

A user wants to run multiple jobs where each uses a distinct combination of input parameters. 

#### Solution

Very similar to Sample_Array_Read_Filenames, the user may generate an input file with the relevant parameter combinations and read individual lines into their array jobs using the array indices.





## Parallel Jobs

### Sample_Parallel_Job

#### Problem
A user wants to run multiple tasks on a single node without using an array job

#### Solution
GNU Parallel allows for the user to submit many tasks to a single node for simultaneous execution (~one task/cpu). Tasks that are not run immediately due to space restrictions are queued behind the running jobs and are executed as space becomes available.

## Parallel + Array Jobs

### Sample_Array_with_GNUParallel

#### Problem

A user wants to run more tasks than the PBS scheduler can keep track of (e.g. thousands)

#### Solution

This script is roughly an extension of Sample_Array_Job.pbs, but with the additional step of parallelizing tasks within each subjob. The parallelization was accomplished using GNU Parallel (https://www.gnu.org/software/parallel/)

