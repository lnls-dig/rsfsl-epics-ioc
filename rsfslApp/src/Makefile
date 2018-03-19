TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = rsfsl
# rsfsl.dbd will be created and installed
DBD += rsfsl.dbd

# rsfsl.dbd will be made up from these files:
rsfsl_DBD += base.dbd

# Include dbd files from all support applications:
#rsfsl_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#rsfsl_LIBS += xxx

# rsfsl_registerRecordDeviceDriver.cpp derives from rsfsl.dbd
rsfsl_SRCS += rsfsl_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
rsfsl_SRCS_DEFAULT += rsfslMain.cpp
rsfsl_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#rsfsl_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
rsfsl_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

rsfsl_DBD += asyn.dbd
rsfsl_DBD += drvAsynIPPort.dbd
rsfsl_DBD += drvVxi11.dbd
rsfsl_DBD += stream.dbd
rsfsl_DBD += calcSupport.dbd
rsfsl_DBD += asSupport.dbd

rsfsl_LIBS += asyn
rsfsl_LIBS += stream
rsfsl_LIBS += calc
rsfsl_LIBS += autosave
