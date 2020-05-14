#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --array 1-2
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=00:10:00
#SBATCH --job-name=array-test
#SBATCH --partition=windfall

export PATH=/xdisk/sarawillis/Puma_Testing/puma_software/bin:$PATH
cd $SLURM_SUBMIT_DIR
BLOCK_SIZE=96

### Prints output to show the task indices, the job ID, node ID, and a possible command that could be executed 

seq $(($SLURM_ARRAY_TASK_ID*$BLOCK_SIZE-$BLOCK_SIZE+1)) $(($SLURM_ARRAY_TASK_ID*$BLOCK_SIZE)) | parallel echo "JOB ID: $SLURM_JOB_ID HOST NODE: $HOSTNAME EXAMPLE COMMAND: ./executable input_{}"
