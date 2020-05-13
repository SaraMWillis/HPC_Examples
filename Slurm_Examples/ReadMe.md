# Slurm Examples

The new cluster at UArizona HPC is moving over from PBS to Slurm for its job scheduler. 



## Environment Variables
| Slurm Variable       | PBS Variable     | Function                          |
|----------------------|------------------|-----------------------------------|
| $SLURM_SUBMIT_DIR    | $PBS_O_WORKDIR   | Directory where job was submitted |
| $SLURM_ARRAY_TASK_ID | $PBS_ARRAY_INDEX | Array Index                       |
| $SLURM_JOB_ID        | $PBS_JOBID       | Job ID                            |
| $SLURM_JOB_NAME      | $PBS_JOBNAME     | Job Name                          |
