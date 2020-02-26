# Walkthrough

Basic_Array_Job is designed to demonstrate how to use an array job to execute the same script multiple times with different input.

_This script was written and executed on elgato, but can be run with minor modifications to the resource requests on ocelote as well_

## What problem does this help fix?
Without an array job, a user may be tempted to submit multiple jobs with a for loop, e.g.:

```
$ for i in $( seq 1 10 ); do qsub script.pbs <submission options> ; done
```
This is *not* a good way to submit scripts. This submits too many jobs too quickly and overloads the system. Instead, an array job can be used to achive the same ends. 

## Script Breakdown

Standard PBS Directives:
```
#!/bin/bash

#PBS -q standard
#PBS -W group_list=<group_name>
#PBS -N Basic_Array_Job
#PBS -l select=1:ncpus=1:mem=4gb:pcmem=4gb
#PBS -l walltime=00:00:30
#PBS -j oe
```

The option ```-J``` tells PBS that you're running an array job. The ```1-10``` will count as the array indices which can be used to differentiate subjobs. In this case, we're running 10 jobs.
```
#PBS -J 1-10
```

To demonstrate how we can use each array index to read in a different file:
```
echo "Job Name: $PBS_JOBID, Reading File: input_file_${PBS_ARRAY_INDEX}.txt"
```

## Script Submission Command
```
$ qsub Basic_Array_Job
```

## Output Files
Each of the subjobs in the array will output its own file of the form ```<job_name>.o<job_ID>.<array_index>``` as seen below:

```
ls -lh
total 0
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.1
-rw------- 1 sarawillis sarawillis  64 Feb 18 10:00 Basic_Array_Job.o87274.10
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.2
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.3
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.4
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.5
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.6
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.7
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.8
-rw------- 1 sarawillis sarawillis  62 Feb 18 10:00 Basic_Array_Job.o87274.9
```

## File Contents

The file included in this repository is a concatenation of all the job's output files as shown by the command below.

```
$ cat Basic_Array_Job.o87274.*
Job Name: 87274[1].elgato-adm, Reading File: input_file_1.txt
Job Name: 87274[10].elgato-adm, Reading File: input_file_10.txt
Job Name: 87274[2].elgato-adm, Reading File: input_file_2.txt
Job Name: 87274[3].elgato-adm, Reading File: input_file_3.txt
Job Name: 87274[4].elgato-adm, Reading File: input_file_4.txt
Job Name: 87274[5].elgato-adm, Reading File: input_file_5.txt
Job Name: 87274[6].elgato-adm, Reading File: input_file_6.txt
Job Name: 87274[7].elgato-adm, Reading File: input_file_7.txt
Job Name: 87274[8].elgato-adm, Reading File: input_file_8.txt
Job Name: 87274[9].elgato-adm, Reading File: input_file_9.txt
```
