# Walkthrough 

Sample_Parallel_Job is designed to demonstrate how to parallelize multiple tasks within one job. 

## What Problem does this help fix?

Like array jobs, this allows multiple tasks to be executed simultaneously with only one job submission. 

## Script Breakdown

Standard PBS Directives:

```
#PBS -q standard
#PBS -W group_list=hpcteam

#PBS -N Sample_Parallel_Job

#PBS -l select=1:ncpus=28:mem=168gb:pcmem=6gb
#PBS -l walltime=00:02:00
```

In this case, I'm using a full node and will make use of it with Gnu Parallel which I access with a module load statement:

```
module load parallel
```

The meat of the command lies here: 

```
seq 1 100 | parallel 'DATE=$( date +"%T" ) && sleep 0.{} && echo "Host: $HOSTNAME ; Date: $DATE; {}"'
```

```seq 1 100``` Generates a list between 1 and 100 (inclusive). We pipe that into a parallel command which will generate one task per element

```parallel``` is how we use Gnu Parallel to execute the tasks. It will find the space on our node as it works through the relevant tasks. Everything in ```'...'``` is the command that will be executed

**Inside the ```'...'```:**

```DATE=$( date +"%T" )``` sets DATE so we can visualize the tasks and when they're being executed

```sleep 0.{}``` An odd choice, sure, but I find it informative. It drives home that tasks are being executed in parallel and not in serial since each task will sleep for 0.n seconds, where n is the input integer from the ```seq``` command. This means, for example, the 2nd task will wait longer than the 10th task, as can be seen in the output file.  

```echo "Host: $HOSTNAME ; Date: $DATE; {}"``` Prints out the relevant information. ```{}``` is the piped input which, in this case, will be an integer between 1 and 100. 

## Script Submission Command
```
$ qsub Sample_Parallel_Job.pbs 
3030688.head1.cm.cluster
```

## Output Files
Since this isn't an array job, there will only be one output (non-error) file:

```
$ ls
Sample_Parallel_Job.e3030688  
Sample_Parallel_Job.o3030688
Sample_Parallel_Job.pbs
```

## File Contents

```
$ cat Sample_Parallel_Job.o3030688 
Host: i10n23 ; Date: 15:04:45; 1
Host: i10n23 ; Date: 15:04:45; 10
Host: i10n23 ; Date: 15:04:45; 11
Host: i10n23 ; Date: 15:04:45; 2
Host: i10n23 ; Date: 15:04:45; 12
Host: i10n23 ; Date: 15:04:45; 13
Host: i10n23 ; Date: 15:04:45; 14
Host: i10n23 ; Date: 15:04:45; 3
Host: i10n23 ; Date: 15:04:45; 4
Host: i10n23 ; Date: 15:04:45; 15
Host: i10n23 ; Date: 15:04:45; 16
Host: i10n23 ; Date: 15:04:45; 5
Host: i10n23 ; Date: 15:04:45; 17
Host: i10n23 ; Date: 15:04:45; 6
Host: i10n23 ; Date: 15:04:45; 18
Host: i10n23 ; Date: 15:04:45; 7
Host: i10n23 ; Date: 15:04:45; 19
Host: i10n23 ; Date: 15:04:45; 20
Host: i10n23 ; Date: 15:04:45; 21
Host: i10n23 ; Date: 15:04:45; 8
Host: i10n23 ; Date: 15:04:45; 22
Host: i10n23 ; Date: 15:04:45; 9
Host: i10n23 ; Date: 15:04:45; 23
Host: i10n23 ; Date: 15:04:45; 24
Host: i10n23 ; Date: 15:04:45; 25
Host: i10n23 ; Date: 15:04:45; 26
Host: i10n23 ; Date: 15:04:45; 27
Host: i10n23 ; Date: 15:04:45; 28
Host: i10n23 ; Date: 15:04:46; 29
Host: i10n23 ; Date: 15:04:46; 30
Host: i10n23 ; Date: 15:04:46; 31
Host: i10n23 ; Date: 15:04:46; 32
Host: i10n23 ; Date: 15:04:46; 33
Host: i10n23 ; Date: 15:04:46; 34
Host: i10n23 ; Date: 15:04:46; 35
Host: i10n23 ; Date: 15:04:46; 36
Host: i10n23 ; Date: 15:04:46; 37
Host: i10n23 ; Date: 15:04:46; 38
Host: i10n23 ; Date: 15:04:46; 39
Host: i10n23 ; Date: 15:04:46; 40
Host: i10n23 ; Date: 15:04:46; 41
Host: i10n23 ; Date: 15:04:46; 42
Host: i10n23 ; Date: 15:04:46; 43
Host: i10n23 ; Date: 15:04:46; 44
Host: i10n23 ; Date: 15:04:46; 45
Host: i10n23 ; Date: 15:04:46; 46
Host: i10n23 ; Date: 15:04:46; 47
Host: i10n23 ; Date: 15:04:46; 48
Host: i10n23 ; Date: 15:04:46; 49
Host: i10n23 ; Date: 15:04:46; 50
Host: i10n23 ; Date: 15:04:47; 51
Host: i10n23 ; Date: 15:04:47; 52
Host: i10n23 ; Date: 15:04:47; 53
Host: i10n23 ; Date: 15:04:47; 54
Host: i10n23 ; Date: 15:04:47; 55
Host: i10n23 ; Date: 15:04:47; 56
Host: i10n23 ; Date: 15:04:47; 57
Host: i10n23 ; Date: 15:04:47; 58
Host: i10n23 ; Date: 15:04:47; 59
Host: i10n23 ; Date: 15:04:47; 60
Host: i10n23 ; Date: 15:04:47; 61
Host: i10n23 ; Date: 15:04:47; 62
Host: i10n23 ; Date: 15:04:47; 63
Host: i10n23 ; Date: 15:04:47; 64
Host: i10n23 ; Date: 15:04:47; 65
Host: i10n23 ; Date: 15:04:47; 66
Host: i10n23 ; Date: 15:04:47; 67
Host: i10n23 ; Date: 15:04:47; 68
Host: i10n23 ; Date: 15:04:47; 69
Host: i10n23 ; Date: 15:04:47; 70
Host: i10n23 ; Date: 15:04:48; 71
Host: i10n23 ; Date: 15:04:48; 72
Host: i10n23 ; Date: 15:04:48; 73
Host: i10n23 ; Date: 15:04:48; 74
Host: i10n23 ; Date: 15:04:48; 75
Host: i10n23 ; Date: 15:04:48; 76
Host: i10n23 ; Date: 15:04:48; 77
Host: i10n23 ; Date: 15:04:48; 78
Host: i10n23 ; Date: 15:04:48; 79
Host: i10n23 ; Date: 15:04:48; 80
Host: i10n23 ; Date: 15:04:48; 81
Host: i10n23 ; Date: 15:04:49; 82
Host: i10n23 ; Date: 15:04:49; 83
Host: i10n23 ; Date: 15:04:49; 84
Host: i10n23 ; Date: 15:04:49; 85
Host: i10n23 ; Date: 15:04:49; 86
Host: i10n23 ; Date: 15:04:50; 100
Host: i10n23 ; Date: 15:04:49; 87
Host: i10n23 ; Date: 15:04:49; 88
Host: i10n23 ; Date: 15:04:50; 89
Host: i10n23 ; Date: 15:04:50; 90
Host: i10n23 ; Date: 15:04:50; 91
Host: i10n23 ; Date: 15:04:50; 92
Host: i10n23 ; Date: 15:04:50; 93
Host: i10n23 ; Date: 15:04:50; 94
Host: i10n23 ; Date: 15:04:50; 95
Host: i10n23 ; Date: 15:04:50; 96
Host: i10n23 ; Date: 15:04:50; 97
Host: i10n23 ; Date: 15:04:50; 98
Host: i10n23 ; Date: 15:04:50; 99
```
