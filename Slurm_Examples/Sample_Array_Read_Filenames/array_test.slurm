#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --array 1-4
#SBATCH --mem-per-cpu=1GB
#SBATCH --oversubscribe
#SBATCH --time=00:10:00
#SBATCH --job-name=array-test
#SBATCH --partition=windfall
#SBATCH --open-mode=append
#SBATCH --output=array-test.out

cd $SLURM_SUBMIT_DIR
CurrentFastaFile="$( sed "${SLURM_ARRAY_TASK_ID}q;d" InputFiles )"
echo "JOB NAME: $SLURM_JOB_ID, EXAMPLE COMMAND: ./executable -o ${CurrentFastaFile}"
