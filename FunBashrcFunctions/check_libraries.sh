#### Checks for available system libraries. User can search using full or partial
#### library name. Function will return names and locations or will report that no
#### library was found.

printf_new() {
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo "${v// /$str}"
}
function library () {
    message="Searching for system libraries matching keyword: $1"
    echo; echo $message
    printf_new "*" ${#message} ; echo
    if [[ $(ldconfig -p | grep $1) ]]; then
        ldconfig -p | grep $1 ; echo
    else
        echo "no libraries found"; echo
fi
}
