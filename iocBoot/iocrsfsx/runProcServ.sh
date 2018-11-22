#!/bin/sh

set -e
set +u

# Parse command-line options
. ./parseCMDOpts.sh "$@"

# Use defaults if not set
if [ -z "${DEVICE_TELNET_PORT}" ]; then
   DEVICE_TELNET_PORT="20000"
fi

if [ -z "${DEVICE_TYPE}" ]; then
   DEVICE_TYPE="FSL"
fi

set -u

# Run run*.sh scripts with procServ
/usr/local/bin/procServ -f -n RS_${DEVICE_TYPE} -i ^C^D ${DEVICE_TELNET_PORT} ./runRSFSx.sh "$@"
