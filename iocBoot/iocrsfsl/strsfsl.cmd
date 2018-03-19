< envPaths
< rsfsl.config

####################################################

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/rsfslApp/Db")

## Register all support components
dbLoadDatabase("$(TOP)/dbd/rsfsl.dbd",0,0)
rsfsl_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadRecords("${TOP}/rsfslApp/Db/rsfsl.db", "P=$(P), R=$(R), PORT=rsfsl_port, ADDR=0, TIMEOUT=1")

# Create the asyn port to use the VXI11 protocol
vxi11Configure("rsfsl_port","$(DEVICE_IP)",0,"0.0","inst0",0,0)

< save_restore.cmd

iocInit

## Start any sequence programs
# No sequencer program

# Create manual trigger for Autosave
create_triggered_set("auto_settings_rsfsl.req", "${P}${R}SaveTrg", "P=${P}, R=${R}")
set_savefile_name("auto_settings_rsfsl.req", "auto_settings_${P}${R}.sav")
