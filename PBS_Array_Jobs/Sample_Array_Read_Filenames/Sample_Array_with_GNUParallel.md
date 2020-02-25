# Sample Array : Read Filenames

#### Problem
Sometimes you want to run multiple jobs where each opens a different file to analyze. What happens if the naming scheme isn't conducive to automating the process using simple array indices (i.e. 1.txt, 2.txt, ...)? 

#### Solution

The user can create an file with one filename per line and read them in using array indices. This script is designed to illustrate this method.

In this example, we assume the working directory contains four fastq files ```SRR2309587.fastq```, ```SRR3050489.fastq```, ```SRR305356.fastq```, and ```SRR305p0982.fastq```. The filenames were then saved to the file ```filenames``` using:

```
$ ls *.fastq > filenames
```

The files were then located by the PBS script using the job array ID to select specific lines from ```filenames```. The specific line that reads in a specific line is:

```
CurrentFastaFile="$( sed "${PBS_ARRAY_INDEX}q;d" InputFiles )"
```
Each job in the array will have an index associated with it. We use these to read in the relevant lines, e.g., for the 3rd job an array, ```PBS_ARRAY_INDEX``` will be 3. The above line will then read in the third line from the input file and will save the text as the variable ```CurrentFastaFile```

### Submitting the Job
``` 
qsub Sample_Array_Read_Filenames

```

A sample command was then printed as output for demonstration purposes. Submitting the file using ```qsub SampleArrayJob_UseInputFiles.pbs``` produces the output files:

```

```
