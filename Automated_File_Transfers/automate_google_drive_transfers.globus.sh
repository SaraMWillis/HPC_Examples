#!/bin/bash

###########################################################################################
# Author : Sara Willis
# Date   : February 14, 2020
#
# This script is designed to transfer a file between two globus endpoints. It was created
# to help integrate data transfers between Google Drive and HPC into pipelines. Right now 
# it functions as a standalone script, but it can modified.
# 
# Usage: ./make_google_transfer [upload|download]
#
# e.g.:
# 
# ./make_google_transfer upload
#     Transfers output_filename from output_files_path on HPC to remote_output_files on 
#     Google Drive
#
# ./make_google_transfer download
#     Transfers input_filename from remote_input_files on Google Drive to input_files_path
#     on HPC.
#
# Otherwise, the program exits with an error. 
#
# The naming scheme was designed to work intuitively with a research pipeline, but if this 
# is confusing, suggestions are encouraged. 
#
#
###########################################################################################
#                               Set User Variables                                        #
###########################################################################################

# User endpoints -- can either get from Globus online console or from CLI
google_drive_endpoint=''
hpc_endpoint=''


# Remote File Paths Information (Google Drive Directories)
remote_input_files=/GlobusCLITestArchives  # Source Directory for Google Drive --> HPC
remote_output_files=/GlobusCLITestArchives # Destination Directory for HPC --> Google Drive


# Local File Paths Information (HPC Directories)
input_files_path=/extra/sarawillis/TestSubmissions/archive # Destination Directory for Google Drive --> HPC
output_files_path=/extra/sarawillis/TestSubmissions/output_archive # Source Directory for HPC --> Google Drive


# Filenames
input_filename=GlobusCLI.tgz # import filename for Google Drive --> HPC. Same at source and destination
output_filename=Output.tgz   # export filename for HPC to Google Drive. Same at source and destination

###########################################################################################



printf "\n\nEntering script to initiate transfers between Google Drive and HPC.\n\n"


# Determine the direction of the transfer. If a valid option is specified, then the transfer
# command is generated
if [ $1 = download ]; then

    # The transfer is printed to the terminal. Helpful for debugging if a transfer fails
    echo "Transfer command initiating: globus transfer $google_drive_endpoint:/$remote_input_files/$input_filename $hpc_endpoint:/$input_files_path/$input_filename"

    # Generates the appropriate transfer command for the direction specified
    transfer_execution_command="globus transfer $google_drive_endpoint\:/$remote_input_files/$input_filename $hpc_endpoint\:/$input_files_path/$input_filename"

elif [ $1 = 'upload' ]; then
    echo "Transfer command initiating: globus transfer $hpc_endpoint:/$output_files_path/$output_filename $google_drive_endpoint:/$remote_output_files/$output_filename"
    transfer_execution_command="globus transfer $hpc_endpoint\:/$output_files_path/$output_filename $google_drive_endpoint\:/$remote_output_files/$output_filename"

else
    printf "A direction needs to be specified to make a file transfer\nUsage: make_google_transfer [upload | download]"
    exit 1
fi


# The transfer command is executed and the Task ID is stored as Task_ID_Label
# It's definitely not unreasonable to believe there's an easier way to get the Task ID. I'll
# look into this.
Task_ID_Label=$( eval $transfer_execution_command | grep 'Task ID')


# Checks exit status. If the globus command us not successfuly executed, script exits with an error.
if [[ $? -ne 0 ]] ; then
    echo -e "\n\nSomething went wrong. Check your input and/or Globus logs and try again."
    exit 1
    
else
    # The Task ID is reformatted so we can check on the transfer progress. 
    Task_ID=${Task_ID_Label/Task ID: /}
    

    # The script is forced to wait two seconds before checking the task status. If it doesn't
    # wait, it may not catch an error since it may move faster than Globus' output
    sleep 2

    # I'm using Globus to print a json-formatted error report. Python reads this in from stdout
    # and checks if there are any error messages. 
    Globus_Error_Status=$(globus task event-list $Task_ID --filter-errors --format json | python3 -c "import sys, json; print(len(json.load(sys.stdin)['DATA']))")

    # Globus_Error_Status is the number of distinct errors thrown by the transfer command. If
    # it's nonzero, the task is killed and the script exits with an error message.
    if [ $Globus_Error_Status -ne 0 ];
    then echo 'A Globus error has occured. Check logs and try again'

    # We kill the process in this case. I've had Globus throw errors and then not shut down,
    # leaving the process hanging indefinitely. This won't fly in a pipeline environment. 
    # These errors usually happen when there's an incorrect path specified (i.e. a directory 
    # doesn't exist that the user is pointing to).
    globus task cancel $Task_ID
    exit 1
    fi

    # If all is well, our script is told to wait until the globus transfer has completed
    # before exiting. 
    globus task wait $Task_ID
    echo "Transfer succeeded"
fi


