TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================
# Build the IOC support library

LIBRARY_IOC += rsfsxSupport

# Link locally-provided code into the support library,
# rather than directly into the IOC application.
rsfsxSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# Build the IOC application

PROD_IOC = rsfsx
# rsfsx.dbd will be created and installed
DBD += rsfsx.dbd

# rsfsx.dbd will be made up from these files:
rsfsx_DBD += base.dbd

# Include dbd files from all support applications:
#rsfsx_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#rsfsx_LIBS += xxx

# rsfsx_registerRecordDeviceDriver.cpp derives from rsfsx.dbd
rsfsx_SRCS += rsfsx_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
rsfsx_SRCS_DEFAULT += rsfsxMain.cpp
rsfsx_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#rsfsx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Link in the code from the support library
rsfsx_LIBS += rsfsxSupport

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

ifneq ($(SNCSEQ),)

    # Build sncSpec into rsfsxSupport
    sncSpec_SNCFLAGS += +r
    rsfsx_DBD += sncSpec.dbd
    rsfsxSupport_SRCS += sncSpecProgram.st
    rsfsxSupport_LIBS += seq pv
    rsfsx_LIBS += seq pv

    # Build sncRSFSx into rsfsxSupport
    sncRSFSxSetup_SNCFLAGS += +r
    rsfsx_DBD += sncRSFSxSetup.dbd
    rsfsxSupport_SRCS += sncRSFSxSetup.stt
    rsfsxSupport_LIBS += seq pv
    rsfsx_LIBS += seq pv

endif

# Finally link to the EPICS Base libraries
rsfsx_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

rsfsx_DBD += asyn.dbd
rsfsx_DBD += drvAsynIPPort.dbd
rsfsx_DBD += drvVxi11.dbd
rsfsx_DBD += stream.dbd
rsfsx_DBD += calcSupport.dbd
rsfsx_DBD += asSupport.dbd
rsfsx_DBD += menuScan.dbd

rsfsx_LIBS += asyn
rsfsx_LIBS += stream
rsfsx_LIBS += calc
rsfsx_LIBS += autosave
