# Walkthrough 

Sample_Array_with_GNUParallel combines the methods of Basic_Array_Job and Sample_Parallel_Job to execute a large number of jobs.

## What problem does this help fix?

Sometimes you need to run a _lot_ of jobs. More than can be reasonably accomplished using arrays since submitting thousands of these can be a problem for the system, and Gnu Parallel is challenging to make work in a multi-node environment. In this case, we can combine the forces of Gnu Parallel and array jobs such that we can distribute a chunk of tasks across multiple nodes where Gnu Parallel will execute them. 

## Script Breakdown

Standard PBS Directives. We'll ask for a full node for each subjob:

```
#!/bin/bash

#PBS -q standard
#PBS -W group_list=<GROUP NAME>

#PBS -N Sample_Array_with_GNUParallel

#PBS -l select=1:ncpus=28:mem=168gb:pcmem=6gb
#PBS -l walltime=00:00:30
```

We'll ask for two subjobs:

```
#PBS -J 1-2
```

Load the relevant parallel module and change to the working directory:

```
module load parallel
cd $PBS_O_WORKDIR
```

This is the part where people get a bit more confused, so we'll go through each step. The general goal here for illustration purposes is to set up a "block size." This is the number of tasks Gnu Parallel will be executing in each subjob. 

```
BLOCK_SIZE=56
```

So in this case, I'm asking for 56 tasks per subjob (this was an arbitrary choice on my end). Since we're submitting an array job with two subjobs, that totals 112 tasks. 

See online resources and [Sample_Parallel_Job](https://github.com/SaraMWillis/HPC_Examples/tree/master/PBS_Array_Jobs/Sample_Parallel_Job) for more information on how to use the parallel command. 

What we'll focus on here is generating the indices we need to differentiate our tasks. ```seq n m``` generates a sequence of integers from ```n``` to ```m``` (inclusive). We'll use this with some arithmetic below:

```
seq $(($PBS_ARRAY_INDEX*$BLOCK_SIZE-$BLOCK_SIZE+1)) $(($PBS_ARRAY_INDEX*$BLOCK_SIZE))
```

```PBS_ARRAY_INDEX``` is either 1 or 2, depending on the subjob. ```BLOCK_SIZE``` is set by the user. In this case, we've set it to 56. Looking at the arithmetic:

**Subjob 1**:
```seq $(($PBS_ARRAY_INDEX*$BLOCK_SIZE-$BLOCK_SIZE+1)) $(($PBS_ARRAY_INDEX*$BLOCK_SIZE))``` = ```seq 1*56-56+1 1*56``` = ```seq 1 56```

**Subjob 2**:
```seq $(($PBS_ARRAY_INDEX*$BLOCK_SIZE-$BLOCK_SIZE+1)) $(($PBS_ARRAY_INDEX*$BLOCK_SIZE))``` = ```seq 2*56-56+1 2*56``` = ```seq 57 112```

Shown by the above, this is just a way to cleanly partition the integers 1 through 112 into two distinct groups. Each group will be assigned to a node.

## Script Submission Command

```
$ qsub Sample_Array_with_GNUParallel.pbs 
3031256[].head1.cm.cluster
```

## Output Files

```
$ ls Sample_Array_with_GNUParallel.o*
Sample_Array_with_GNUParallel.o3031256.1
Sample_Array_with_GNUParallel.o3031256.2
```

## File Contents

Below, you can see that 112 jobs were run using an array job with two subjobs on two nodes, i4n22 and i4n20.
```
$ cat Sample_Array_with_GNUParallel.o*
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_1
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_2
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_3
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_4
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_5
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_6
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_7
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_8
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_9
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_10
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_11
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_12
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_13
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_14
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_15
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_16
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_17
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_18
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_19
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_20
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_21
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_22
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_23
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_24
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_25
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_26
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_27
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_28
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_29
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_30
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_31
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_32
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_33
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_34
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_35
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_36
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_37
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_38
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_39
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_40
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_41
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_42
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_43
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_44
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_45
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_46
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_47
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_48
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_49
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_50
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_51
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_52
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_53
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_54
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_55
JOB ID: 3031256[1].head1.cm.cluster HOST NODE: i4n22 EXAMPLE COMMAND: ./executable input_56
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_57
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_58
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_59
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_60
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_61
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_62
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_63
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_64
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_65
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_66
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_67
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_68
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_69
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_70
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_71
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_72
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_73
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_74
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_75
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_76
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_77
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_78
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_79
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_80
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_81
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_82
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_83
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_84
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_85
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_86
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_87
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_88
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_89
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_90
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_91
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_92
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_93
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_94
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_95
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_96
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_97
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_98
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_99
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_100
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_101
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_102
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_103
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_104
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_105
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_106
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_107
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_108
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_109
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_110
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_111
JOB ID: 3031256[2].head1.cm.cluster HOST NODE: i4n20 EXAMPLE COMMAND: ./executable input_112
```
