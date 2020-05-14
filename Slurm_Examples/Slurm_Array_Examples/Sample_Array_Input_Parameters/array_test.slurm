#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --array 1-10
#SBATCH --mem-per-cpu=1GB
#SBATCH --oversubscribe
#SBATCH --time=00:10:00
#SBATCH --job-name=array-test
#SBATCH --partition=windfall
#SBATCH --open-mode=append
#SBATCH --output=array-test.out

cd $SLURM_SUBMIT_DIR

read first_parameter second_parameter third_parameter <<< $( sed "${SLURM_ARRAY_TASK_ID}q;d" input_parameters )

echo "Job ID: $SLURM_JOB_ID ; Host Node : $HOSTNAME ; Sample Command : ./executable $first_parameter $second_parameter $third_parameter"
