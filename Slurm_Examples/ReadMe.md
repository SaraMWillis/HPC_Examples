# Slurm Examples

slurm_cheat_sheet is something I keep as a hidden file in my home directory on HPC. I have an alias set up so I can type ```shelp``` which prints the contents to my terminal.


## Environment Variables
| Slurm Variable       | PBS Variable     | Function                                  |
|----------------------|------------------|-------------------------------------------|
| $SLURM_SUBMIT_DIR    | $PBS_O_WORKDIR   | Path to directory where job was submitted |
| $SLURM_ARRAY_TASK_ID | $PBS_ARRAY_INDEX | Array Index                               |
| $SLURM_JOB_ID        | $PBS_JOBID       | Job ID                                    |
| $SLURM_JOB_NAME      | $PBS_JOBNAME     | Job Name                                  |
