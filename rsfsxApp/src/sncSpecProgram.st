program sncSpec

%%#include <stdlib.h>
%%#include <math.h>
#define specArraySize 160005

%%//----------------------------------------
%%// 	      Monitored PVs
%%//----------------------------------------

float trace[32001];
assign trace to "{P}{R}Trace-Mon";

float specArray[specArraySize];
assign specArray to "{P}{R}SpecArray-Mon";

int swePts;
assign swePts to "{P}{R}SwePts-RB";
monitor swePts;
evflag swePtsFlag;
sync swePts swePtsFlag;

int frameCount;
assign frameCount to "{P}{R}FrameCount-Mon";
monitor frameCount;

uint32_t traceHash;
assign traceHash to "{P}{R}Trace-Mon.HASH";
monitor traceHash;
evflag traceHashFlag;
sync traceHash traceHashFlag;

double SpecTime;
assign SpecTime to "{P}{R}SpecTime-SP";
monitor SpecTime;

int specMode;
assign specMode to "{P}{R}SpecMode-Sel";
monitor specMode;
evflag specModeFlag;
sync specMode specModeFlag;

double timeStamp;
assign timeStamp to "{P}{R}TimeStamp";
monitor timeStamp;
evflag timeStampFlag;
sync timeStamp timeStampFlag;

double timeStampInit;
assign timeStampInit to "{P}{R}TimeStampInit-Mon";

double timeStampEnd;
assign timeStampEnd to "{P}{R}TimeStampEnd-Mon";

double timeDelta;
assign timeDelta to "{P}{R}TimeDelta-Mon";

double timestampTrace, timestampGlobal, timestamp_prev;

%% void shiftArrayFloat(float des[], float src[], int shift, int arraySize);

ss spectrogram {

    state TimeWindowACQ {

        when (efTestAndClear(specModeFlag) && specMode == 1) {
            printf("\nSpectrogram Mode: Continuous\n");
        } state ContinuousACQ

        when (efTestAndClear(traceHashFlag)) {

            pvGet(trace, SYNC);
            timestampTrace = pvTimeStamp(trace).secPastEpoch + (double)(pvTimeStamp(trace).nsec)/1000000000;

            if ((timestampTrace - timeStampInit)*1000 >= SpecTime && frameCount > 0){
                pvPut(specArray, SYNC);
                pvPut(frameCount, SYNC);
                frameCount = 0;
                timeStampEnd = timestamp_prev;
                timeDelta = round((timeStampEnd - timeStampInit)*1000);
                pvPut(timeDelta, SYNC);
                pvPut(timeStampEnd, SYNC);
            }

            if (frameCount == 0) {
                timeStampInit = timestampTrace;
                pvPut(timeStampInit, SYNC);
            }

            timestamp_prev = timestampTrace;
            frameCount = frameCount + 1;
            shiftArrayFloat(specArray, trace, swePts, specArraySize);
            efClear(timeStampFlag);

        } state TimeWindowACQ

        when (efTestAndClear(timeStampFlag)) {

            timestampGlobal = pvTimeStamp(timeStamp).secPastEpoch + (double)(pvTimeStamp(timeStamp).nsec)/1000000000;

            // Energy ramp ended
            if (((timestampGlobal - timeStampInit)*1000 >= SpecTime || (timestampGlobal - timestamp_prev)*1000 >= SpecTime) && frameCount > 0) {
                pvPut(specArray, SYNC);
                pvPut(frameCount, SYNC);
                frameCount = 0;
                timeStampEnd = timestamp_prev;
                timeDelta = round((timeStampEnd - timeStampInit)*1000);
                pvPut(timeDelta, SYNC);
                pvPut(timeStampEnd, SYNC);
            }
            efClear(traceHashFlag);

        } state TimeWindowACQ

    }

    state ContinuousACQ {

        entry {
            frameCount = 0;
            pvPut(frameCount, SYNC);
        }

        when (efTestAndClear(specModeFlag) && specMode == 0) {

            printf("\nSpectrogram Mode: Time Window\n");

        } state TimeWindowACQ

        when (efTestAndClear(swePtsFlag)) {

            frameCount = 0;

        } state ContinuousACQ

        when (efTestAndClear(traceHashFlag)) {

            pvGet(trace, SYNC);
            timestampTrace = pvTimeStamp(trace).secPastEpoch + (double)(pvTimeStamp(trace).nsec)/1000000000;
            shiftArrayFloat(specArray, trace, swePts, specArraySize);
            pvPut(specArray, SYNC);

            if (frameCount == 0) {
                timeStampInit = timestampTrace;
                pvPut(timeStampInit, SYNC);
            }

            if ((frameCount + 1)*swePts < specArraySize) {
                frameCount = frameCount + 1;
                pvPut(frameCount, SYNC);
                timeStampEnd = timestampTrace;
                pvPut(timeStampEnd, SYNC);
                timeDelta = round((timeStampEnd - timeStampInit)*1000);
                pvPut(timeDelta, SYNC);
            }

        } state ContinuousACQ

    }
}

%{
    void shiftArrayFloat(float des[], float src[], int shift, int arraySize) {
        memmove(des+shift, des, (arraySize-shift)*sizeof(float));
        memcpy(des, src, shift*sizeof(float));
    }
}%
