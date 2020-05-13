# Conda initializations can cause a lot of woes in HPC and can affect
# the functionality of things ranging from R installations to usage of 
# OOD and even the ability to log in.
# Because of this, I like to control when my conda environment is 
# activated. This function is designed to suppress the activation
# of anaconda until the user chooses by executing the command "xconda"

# for anaconda3. User should modify to anaconda2 if applicable

# NOTE: running xconda in a batch job will not activate the environment

# Location where anaconda is installed
CONDAROOT=$HOME

if [ $HOSTNAME = 'login2' ] || [ $HOSTNAME = 'login3' ]
   then export CLUSTER=Ocelote
elif [ $HOSTNAME = 'login' ]
   then export CLUSTER=ElGato
fi


function xconda () {
    export CONDA='True';
    source ~/.bashrc
}


if [ -z "$CONDA" ]; then
    :
    if [ -z "$CLUSTER" ]; then
        : # suppresses message if not on login node. Message with sftp on filexfer will cause issues
    else
        echo "Conda environment inactive. To activate use: xconda"
    fi
else
    if [ $CONDA = 'True' ]; then
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$CONDAROOT/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$CONDAROOT/anaconda3/etc/profile.d/conda.sh" ]; then
                . "$CONDAROOT/anaconda3/etc/profile.d/conda.sh" 
            else
                export PATH="$CONDAROOT/anaconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    fi
fi
