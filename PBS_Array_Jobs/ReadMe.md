# Read Me

_This repository is still a work in progress and may have half-finished thoughts/poor documentation/inconsistencies. I'm working on cleaning this up_

## About
Figuring out effective ways to submit large numbers of jobs can be frustrating. This repository is designed to try to help implement different techniques to run jobs as arrays/in parallel. They are written for submission with PBS scheduling software on University of Arizona's HPC. 

As a note, these scripts have typically been written in response to submitted user questions and as such may have some idiosynchracies that are specific to each case (I'm working to iron them out to make each example more uniform). Each script is designed to print commands and information specific to that job for better visualization/demonstration purposes. 

HPC users should be able to run each script with minor modifications to experiment.


### What are some problems that arise when submitting lots of jobs?

Common things that can wreak havoc on HPC are submissions that overload our scheduling software. This typically boils down to two things:

1. Submitting individual jobs with for loops    -- Too many jobs/Jobs submitted too quickly
2. Submitting a tremendous number of array jobs -- Too many jobs for the scheduler to keep track of

This can lead to low/nonexistent system performance and unhappy users. This is designed to be an expanding repo of techniques that will run jobs more efficiently without putting as much stress on the system. 


# Scripts


## 1 Sample_Array_Job.pbs

Designed to illustrate a basic job array.







## 2 SampleArrayJob_ReadInInputFilenames.pbs


#### Problem
Sometimes you want to run multiple jobs where each opens a different file to analyze. What happens if the naming scheme isn't conducive to automating the process using simple array indices (i.e. 1.txt, 2.txt, ...)? 

#### Solution

The user can create an file with one filename per line and read them in using array indices. This script is designed to illustrate this method.

In this example, the working directory was made to contain four fastq files: ```SRR2309587.fastq```, ```SRR3050489.fastq```, ```SRR305356.fastq```, and ```SRR305p0982.fastq```. The filenames were then saved to the file ```filenames```:

```
$ ls *.fastq > filenames
```

The files were located by the PBS script using the job array ID to select specific lines from ```filenames```.

A sample command was then printed as output for demonstration purposes. Submitting the file using ```qsub SampleArrayJob_UseInputFiles.pbs``` produces the output:

```
$ cat Sample_Array_Script.o*
Job Name: 2914903[1].head1.cm.cluster
./executable -o output1 SRR2309587.fastq
Job Name: 2914903[2].head1.cm.cluster
./executable -o output2 SRR3050489.fastq
Job Name: 2914903[3].head1.cm.cluster
./executable -o output3 SRR305356.fastq
Job Name: 2914903[4].head1.cm.cluster
./executable -o output4 SRR305p0982.fastq
```


## 3 Sample_Array_with_GNUParallel.pbs

This script is roughly an extension of Sample_Array_Job.pbs, but with the additional step of parallelizing tasks within each subjob. This is effective for efficiently running a large number of single-core processes. Submitting many (~thousands) of jobs can overwhelm the scheduler leading to less than optimal system performance. When each subjob is a single task only using one core, they can be combined to run in parallel. This allows a large number to be run simultaneously without submitting each individual task as its own subjob. 

The parallelization was accomplished using GNU Parallel (https://www.gnu.org/software/parallel/)

The output is for demonstration purposes. It shows the job ID, array index, the subjob's host node, and a possible command (running an R script) which includes the task index.

submission:
```
$ qsub Sample_Array_with_GNUParallel.pbs
```

Output:

```
$ cat Array_Parallel_Testing.o*
2907196[1].head1.cm.cluster i4n17 Rscript sample_script.R 1 RO2
2907196[1].head1.cm.cluster i4n17 Rscript sample_script.R 2 RO2
2907196[1].head1.cm.cluster i4n17 Rscript sample_script.R 3 RO2
2907196[1].head1.cm.cluster i4n17 Rscript sample_script.R 4 RO2
2907196[2].head1.cm.cluster i4n14 Rscript sample_script.R 5 RO2
2907196[2].head1.cm.cluster i4n14 Rscript sample_script.R 6 RO2
2907196[2].head1.cm.cluster i4n14 Rscript sample_script.R 7 RO2
2907196[2].head1.cm.cluster i4n14 Rscript sample_script.R 8 RO2
```
