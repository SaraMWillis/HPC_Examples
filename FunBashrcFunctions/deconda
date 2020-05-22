# Deactivates anaconda/miniconda and removes any instances of it from $PATH
function deconda () {
    conda deactivate > /dev/null 2>&1
    IFS=':' read -ra PATHAR <<< "$PATH"
    for i in "${PATHAR[@]}"
        do if [[ $i == *"conda"* ]]
            then echo "removing $i from PATH"
        else NEWPATH=$i:$NEWPATH
        fi
    done
    export PATH=$NEWPATH
    export NEWPATH=
    echo ; echo "Successfully removed conda"
}
