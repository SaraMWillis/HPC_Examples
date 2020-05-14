#!/bin/bash

USER_EMAIL=""
ENDPOINT_ID=""
MIN_SECONDS=259200 # If fewer seconds exist than this limit, user will receive email (current: 3 days)

CERTIFICATE_INFO=$( globus endpoint is-activated -F json $ENDPOINT_ID | python3 -c "import json, sys; globus_status=json.load(sys.stdin) ; print(globus_status['activated'],globus_status['expires_in'],globus_status['expire_time'])" )
CERTIFICATE_ARR=($CERTIFICATE_INFO)
ACTIVE=${CERTIFICATE_ARR[0]}
TIME_REM=${CERTIFICATE_ARR[1]}
DAY_EXP=${CERTIFICATE_ARR[2]}
HOUR_EXP=${CERTIFICATE_ARR[3]}


if [ $ACTIVE == False ]; then
    printf "Subject: Globus Certificate Expired\n
          This message is to inform you that your UArizona Globus certificate has expired. 
          To renew, visit: www.globus.org" > globus_email.tmp
    sendmail $USER_EMAIL <globus_email.tmp
    rm globus_email.tmp
elif [ $TIME_REM -lt $MIN_SECONDS ] ; then
    printf "Subject: Globus Certificate Expiring\n
            This message is to inform you that your UArizona certificate will be expiring soon. 
            Expiration Date: $DAY_EXP, Expiration Time: $HOUR_EXP
            To renew your certificate, visit: www.globus.org" > globus_email.tmp
    sendmail $USER_EMAIL <globus_email.tmp
    rm globus_email.tmp
else
    :
fi
