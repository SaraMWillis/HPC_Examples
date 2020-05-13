# Unpacks rpm files without root
function unrpm() {
    rpm2cpio $1 | cpio -idv
}
