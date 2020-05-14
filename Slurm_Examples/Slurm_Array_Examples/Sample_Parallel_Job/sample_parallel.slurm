#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --mem-per-cpu=1GB
#SBATCH --oversubscribe
#SBATCH --time=00:10:00
#SBATCH --job-name=array-test
#SBATCH --partition=windfall
#SBATCH --open-mode=append
#SBATCH --output=array-test.out


### Will update to module when available on system
export PATH=/xdisk/sarawillis/Puma_Testing/puma_software/bin:$PATH
cd $SLURM_SUBMIT_DIR
seq 1 100 | parallel 'DATE=$( date +"%T" ) && sleep 0.{} && echo "Host: $HOSTNAME ; Date: $DATE; {}"'
