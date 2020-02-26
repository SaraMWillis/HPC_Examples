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


## Basic_Array_Job

#### Problem

A user wants to submit multiple jobs using the same script with different input.

#### Solution

Using an array job can run multiple tasks and differentiate them using array indices. The tasks are run using only one ```qsub``` command.


## Sample_Array_Read_Filenames


#### Problem

A user wants to run multiple jobs where each opens a different file to analyze but the naming scheme isn't conducive to automating the process using simple array indices as shown in Basic_Array_Job (i.e. 1.txt, 2.txt, ...)? 

#### Solution

The user can create an file with one filename per line and read them in using array indices. 


## Sample_Array_with_GNUParallel

#### Problem

A user wants to run more tasks than the PBS scheduler can keep track of (e.g. thousands)

#### Solution

This script is roughly an extension of Sample_Array_Job.pbs, but with the additional step of parallelizing tasks within each subjob. The parallelization was accomplished using GNU Parallel (https://www.gnu.org/software/parallel/)

