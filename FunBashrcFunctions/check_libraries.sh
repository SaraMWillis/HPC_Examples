#### Checks for available system libraries. Input: full or partial library names

function library () {
    message="Searching for system libraries matching keyword: $1"
    echo; echo $message
    num=${#message}
    v=$(printf "%-${num}s" "$message")
    echo "${v// /$str}" ; echo
    if [[ $(ldconfig -p | grep $1) ]]; then
        ldconfig -p | grep $1 ; echo
    else
        echo "no libraries found"; echo
fi
}
