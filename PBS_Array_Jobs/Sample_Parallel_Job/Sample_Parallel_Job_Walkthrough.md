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

```seq 1 100``` Generates a list between 1 and 100 (inclusive). We pipe that into a parallel command which will generate a task per element

```parallel``` is how we use Gnu Parallel to execute the tasks. It will find the space on our node as it works through the relevant tasks. Everything in ```'...'``` is what will be executed

Inside the ```'...'```:

```DATE=$( date +"%T" )``` sets DATE for print out so we can visualize the tasks and how they're being executed

```sleep 0.{}``` An odd choice, sure, but I find it informative. It drives home that tasks are being executed in parallel and not in serial since each task will sleep for 0.n seconds, where n is the input integer from the ```seq``` command. This means, for example, the 9th task will wait longer than the 17th task, as can be seen in the output file.  

```echo "Host: $HOSTNAME ; Date: $DATE; {}"``` Prints out the relevant information. ```{}``` is the piped input which, in this case, will be an integer between 1 and 100. 

## Script Submission Command
```
$ qsub Sample_Parallel_Job.pbs 
3030688.head1.cm.cluster
```

## Output Files
Since this isn't an array job, there will only be one output file:

```
```

## File Contents

```

```
