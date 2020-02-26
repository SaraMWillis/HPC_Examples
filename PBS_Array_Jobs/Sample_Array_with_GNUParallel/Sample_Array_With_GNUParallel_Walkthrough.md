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

This is the part where people get a bit more confused, so I'll try to break it down. The general goal here for illustration purposes is to set up a "block size." This is the number of tasks Gnu Parallel will be executing in each subjob. 

```
BLOCK_SIZE=56
```

So in this case, I'm asking for 56 tasks per subjob. Since we're submitting an array job with two subjobs, that totals 112 tasks. 

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


## File Contents
