#!/usr/bin/env bash

set -u

if [ -z "$RSFSX_INSTANCE" ]; then
    echo "RSFSX_INSTANCE environment variable is not set." >&2
    exit 1
fi

export RSFSX_CURRENT_PV_AREA_PREFIX=RSFSX_${RSFSX_INSTANCE}_PV_AREA_PREFIX
export RSFSX_CURRENT_PV_DEVICE_PREFIX=RSFSX_${RSFSX_INSTANCE}_PV_DEVICE_PREFIX
export RSFSX_CURRENT_DEVICE_IP=RSFSX_${RSFSX_INSTANCE}_DEVICE_IP
export RSFSX_CURRENT_DEVICE_TELNET_PORT=RSFSX_${RSFSX_INSTANCE}_TELNET_PORT
# Only works with bash
export RSFSX_PV_AREA_PREFIX=${!RSFSX_CURRENT_PV_AREA_PREFIX}
export RSFSX_PV_DEVICE_PREFIX=${!RSFSX_CURRENT_PV_DEVICE_PREFIX}
export RSFSX_DEVICE_IP=${!RSFSX_CURRENT_DEVICE_IP}
export RSFSX_DEVICE_TELNET_PORT=${!RSFSX_CURRENT_DEVICE_TELNET_PORT}

if [ -z "${RSFSX_CURRENT_DEVICE_TELNET_PORT}" ]; then
    echo "TELNET port is not set." >&2
    exit 1
fi

RSFSX_TYPE=$(echo ${RSFSX_INSTANCE} | grep -Eo "[^0-9]+");

if [ -z "$RSFSX_TYPE" ]; then
    echo "Device instance is invalid. Valid device options are: FSV, FSL." >&2
    echo "The instance format is: <device type><device index>. Example: FSL1" >&2
    exit 5
fi

./runProcServ.sh \
    -t "${RSFSX_DEVICE_TELNET_PORT}" \
    -i "${RSFSX_DEVICE_IP}" \
    -d "${RSFSX_TYPE}" \
    -P "${RSFSX_PV_AREA_PREFIX}" \
    -R "${RSFSX_PV_DEVICE_PREFIX}"
