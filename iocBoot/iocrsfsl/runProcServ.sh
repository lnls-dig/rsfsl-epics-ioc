#!/bin/sh

# Use defaults is not set
if [ -z "${RSFSL_DEVICE_TELNET_PORT}" ]; then
    RSFSL_DEVICE_TELNET_PORT=20000
fi

# Run run*.sh scripts with procServ
/usr/local/bin/procServ -f -n rsfsl${RSFSL_INSTANCE} -i ^C^D ${RSFSL_DEVICE_TELNET_PORT} ./runrsfsl.sh "$@"
