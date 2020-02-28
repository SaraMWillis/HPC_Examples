# Sample Array : Read Filenames

#### Problem
Sometimes you want to run multiple jobs where each opens a different file to analyze. What happens if the naming scheme isn't conducive to automating the process using simple array indices (i.e. 1.txt, 2.txt, ...)? 

#### Solution

The user can create a file with one filename per line and read them in using array indices. This script is designed to illustrate this method.

In this example, we assume the working directory contains four fastq files ```SRR2309587.fastq```, ```SRR3050489.fastq```, ```SRR305356.fastq```, and ```SRR305p0982.fastq```. They can be saved to the file ```InputFiles``` using:

```
$ ls *.fastq > InputFiles
```

The files are located by the PBS script using the job array ID to select individual lines from ```InputFiles```. The specific line that reads in a filename is:

```
CurrentFastaFile="$( sed "${PBS_ARRAY_INDEX}q;d" InputFiles )"
```

Each job in the array will have an index associated with it. We use these to read in the relevant lines, e.g., for the 3rd job in an array, ```PBS_ARRAY_INDEX``` will be 3. The above line will then read in the third line from the input file and will save the text as the variable ```CurrentFastaFile```

### Script Breakdown

PBS Directives
```
#!/bin/bash

#PBS -q standard
#PBS -W group_list=<group name>

#PBS -N Sample_Array_Read_Filenames
 
#PBS -l select=1:ncpus=1:mem=6gb:pcmem=6gb
#PBS -l walltime=00:00:30

#PBS -J 1-4

### Change to the directory where the PBS script was submitted
cd $PBS_O_WORKDIR
```
The important line that makes this an array job above is 
```
#PBS -J 1-4
```
The ```-J``` option tells PBS that you want to submit the script as an array. In this case, we are submitting this script four times with PBS array indices 1 through 4 (inclusive). For each of these jobs, we'll make use of the array index to differentiate the input/output:

```
### Pull filename from line number = PBS_ARRAY_INDEX
CurrentFastaFile="$( sed "${PBS_ARRAY_INDEX}q;d" InputFiles )"
```
As described in the section above, each job uses this command to pull the line number from ```InputFiles``` that corresponds to the index number. 

Finally, we print job information and a possible command that could be executed for demonstration/visualization purposes.
```
### Prints job number and possible command for demonstration purposes
echo "JOB NAME: $PBS_JOBID, EXAMPLE COMMAND: ./executable -o output${PBS_ARRAY_INDEX} ${CurrentFastaFile}"
```

### Submitting the Job
``` 
$ qsub Sample_Array_Read_Filenames.pbs 
3029881[].head1.cm.cluster # Job ID specific to my case

```

### Output Files
Each of the subjobs in the array will output its own file of the form ```<job_name>.o<job_ID>.<array_index>``` as seen below:

```
$ ls -lh Sample_Array_Read_Filenames.o3029881.*
-rw------- 1 sarawillis hpcteam 97 Feb 26 11:28 Sample_Array_Read_Filenames.o3029881.1
-rw------- 1 sarawillis hpcteam 97 Feb 26 11:28 Sample_Array_Read_Filenames.o3029881.2
-rw------- 1 sarawillis hpcteam 96 Feb 26 11:28 Sample_Array_Read_Filenames.o3029881.3
-rw------- 1 sarawillis hpcteam 98 Feb 26 11:28 Sample_Array_Read_Filenames.o3029881.4
```

### File Contents
The file included in this repository is a concatenation of all the job's output files as shown by the command below:

```
$ cat Sample_Array_Read_Filenames.o*
JOB NAME: 3029881[1].head1.cm.cluster, EXAMPLE COMMAND: ./executable -o output1 SRR2309587.fastq
JOB NAME: 3029881[2].head1.cm.cluster, EXAMPLE COMMAND: ./executable -o output2 SRR3050489.fastq
JOB NAME: 3029881[3].head1.cm.cluster, EXAMPLE COMMAND: ./executable -o output3 SRR305356.fastq
JOB NAME: 3029881[4].head1.cm.cluster, EXAMPLE COMMAND: ./executable -o output4 SRR305p0982.fastq
```
