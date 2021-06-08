#!/bin/sh

set -e
set +u

# Parse command-line options
. ./parseCMDOpts.sh "$@"

# Use defaults if not set
UNIX_SOCKET=""
if [ -z "${DEVICE_TELNET_PORT}" ]; then
    UNIX_SOCKET="true"
fi

if [ -z "${DEVICE_TYPE}" ]; then
   DEVICE_TYPE="FSL"
fi

set -u

# Run run*.sh scripts with procServ
if [ "${UNIX_SOCKET}" ]; then
    /usr/local/bin/procServ -f -n RS_${DEVICE_TYPE} -i ^C^D unix:./procserv.sock ./runRSFSx.sh "$@"
else
    /usr/local/bin/procServ -f -n RS_${DEVICE_TYPE} -i ^C^D ${DEVICE_TELNET_PORT} ./runRSFSx.sh "$@"
fi
