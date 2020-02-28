# Walkthrough

Sample_Array_Input_Parameters shows how to feed parameters to different subjobs in an array by pulling them from an input file. 

## What problem does this help fix?

If a user wants to submit multiple jobs with differing input parameters, e.g.

* job 1: ```./executable job1_variable1 job1_variable2 job1_variable3```
* job 2: ```./executable job2_variable1 job2_variable2 job2_variable3```
* etc...

they might be initially tempted to write something like a nested for loop to submit their jobs, depending on their specific situation, which is bad practice. Instead, users can have their array jobs read in an input file to pass the arguments.

## Script Breakdown

Standard PBS Directives.

```
#!/bin/bash

#PBS -q standard
#PBS -W group_list=<GROUP NAME>

#PBS -N Sample_Array_Input_Parameters

#PBS -l select=1:ncpus=1:mem=6gb:pcmem=6gb
#PBS -l walltime=00:00:10
```

Asks for an array job with 10 elements:
```
#PBS -J 1-10
```

Change to directory where pbs file is located. The input parameters file should be here, wherever you're navigating, or its path should be specified.
```
cd $PBS_O_WORKDIR
```

We read in the line number that corresponds with the job's PBS_ARRAY_INDEX. The parameters here should be space-delimited. There are three parameters per line that are assigned to the variables on the left.
```
read first_parameter second_parameter third_parameter <<< $( sed "${PBS_ARRAY_INDEX}q;d" input_parameters )
```

Prints a possible command the user could execute as well as other information about the job

```
echo "Job ID: $PBS_JOBID ; Host Node : $HOSTNAME ; Sample Command : ./executable $first_parameter $second_parameter $third_parameter"
```



## Script Submission Command

```
$ qsub Sample_Array_Input_Parameters
3032549[].head1.cm.cluster
```

## Output Files

```
$ ls -lh Sample_Array_Input_Parameters.o*
-rw------- 1 sarawillis hpcteam 273 Feb 27 14:12 Sample_Array_Input_Parameters.o3032549.1
-rw------- 1 sarawillis hpcteam 149 Feb 27 14:45 Sample_Array_Input_Parameters.o3032549.10
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.2
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.3
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.4
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.5
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.6
-rw------- 1 sarawillis hpcteam 124 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.7
-rw------- 1 sarawillis hpcteam 123 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.8
-rw------- 1 sarawillis hpcteam 123 Feb 27 14:48 Sample_Array_Input_Parameters.o3032549.9
```

## File Contents

```
$ cat Sample_Array_Input_Parameters.o*
Job ID: 3032549[1].head1.cm.cluster ; Host Node : i4n22 ; Sample Command : ./executable job1_param1 job1_param2 job1_param3
Job ID: 3032549[10].head1.cm.cluster ; Host Node : i8n3 ; Sample Command : ./executable job10_param1 job10_param2 job10_param3
Job ID: 3032549[2].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job2_param1 job2_param2 job2_param3
Job ID: 3032549[3].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job3_param1 job3_param2 job3_param3
Job ID: 3032549[4].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job4_param1 job4_param2 job4_param3
Job ID: 3032549[5].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job5_param1 job5_param2 job5_param3
Job ID: 3032549[6].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job6_param1 job6_param2 job6_param3
Job ID: 3032549[7].head1.cm.cluster ; Host Node : i5n21 ; Sample Command : ./executable job7_param1 job7_param2 job7_param3
Job ID: 3032549[8].head1.cm.cluster ; Host Node : i8n3 ; Sample Command : ./executable job8_param1 job8_param2 job8_param3
Job ID: 3032549[9].head1.cm.cluster ; Host Node : i8n3 ; Sample Command : ./executable job9_param1 job9_param2 job9_param3
```
