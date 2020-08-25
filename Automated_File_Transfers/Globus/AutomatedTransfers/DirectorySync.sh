#!/bin/bash
# Author: Todd Merritt
# get the endpoint uuids from the web console or from  the output of
# globus endpoint search "endpoint name here"
SRC_EP=""
DST_EP=""
# get list of files on destination endpoint
# and read it into the bash array dst_files
mapfile -t dst_files < <(globus ls ${DST_EP})
# get list of files on source endpoint
for f in `globus ls ${SRC_EP}:/arizona.edu/`; do
  # see if the source file exists at the destination already
  printf '%s\n' "${dst_files[@]}" | grep -q -P "^${f}$"
  if [ $? -eq 1 ]; then
    # it doesn't exist so schedule a transfer
    globus transfer --label "report_sync" ${SRC_EP}:/arizona.edu/${f} ${DST_EP}:${f}
  fi
done
