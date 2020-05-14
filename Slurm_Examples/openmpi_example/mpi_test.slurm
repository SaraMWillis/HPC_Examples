#!/bin/bash
#SBATCH -N 2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=1GB
#SBATCH --oversubscribe
#SBATCH --time=00:10:00
#SBATCH --job-name=mpi-test
#SBATCH --partition=windfall
#SBATCH --output=slurm-test.out

# will replace with module syntax when available
/opt/ohpc/pub/mpi/openmpi3-gnu8/3.1.4/bin/mpirun -n 8 mpi_hello_world
