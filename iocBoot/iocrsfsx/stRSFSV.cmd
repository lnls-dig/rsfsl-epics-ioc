< envPaths

epicsEnvSet("TOP", "../..")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/rsfsxApp/Db")

< RSFSX.config
< RSFSV.config

####################################################


## Register all support components
dbLoadDatabase("$(TOP)/dbd/rsfsx.dbd",0,0)
rsfsx_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadRecords("${TOP}/rsfsxApp/Db/rsfsx.db", "P=$(P), R=$(R), PORT=$(RSFSX_PORT), ADDR=0, TIMEOUT=1")
dbLoadRecords("${TOP}/rsfsxApp/Db/rsfsv.db", "P=$(P), R=$(R), PORT=$(RSFSX_PORT), ADDR=0, TIMEOUT=1")

# Create the asyn port to use the VXI11 protocol
vxi11Configure("$(RSFSX_PORT)","$(IPADDR)",0,"0.0","inst0",0,0)

< save_restore.cmd

iocInit

## Start any sequence programs
seq sncRSFSV, "P=${P}, R=${R}"

# Create manual trigger for Autosave
create_monitor_set("auto_settings_rsfsv.req", 30, "P=${P}, R=${R}")
create_triggered_set("auto_settings_rsfsv.req", "${P}${R}Save-Cmd", "P=${P}, R=${R}")
set_savefile_name("auto_settings_rsfsv.req", "auto_settings_${P}${R}.sav")
