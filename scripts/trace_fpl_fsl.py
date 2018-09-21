from numpy import *
import time
import vxi11
from matplotlib.pyplot import *
from epics import caget, camonitor

FSL = '10.0.18.60'
FPL = '10.0.18.50'

IP = FSL

instr =  vxi11.Instrument(IP)
print instr.ask("*IDN?") # instrument identification
instr.write("SENS:BWID:VID:AUTO OFF") #vbw off
print '\n'

CFlist = [100e6, 350e6, 500e6] # center freq list 
spanlist = [10000, 130000, 300000] # span list
rbwlist = [100] # rbw list

tracelenlist = [801, 2401, 4001, 8001, 10401, 16001, 32001, 64001] # trace len static options

samp_num = 10 # number of samples to calculate de average acquisition time

for CF in CFlist:
  for span in spanlist:
    for rbw in rbwlist:
      if (rbw >= span): # only rbw < span are acceptable
        break
      
      ##### Setup #####
      instr.write("SENS:FREQ:CENT "+str(CF))
      print 'Center Freq', instr.ask("SENS:FREQ:CENT?")

      instr.write("SENS:FREQ:SPAN "+str(span))
      print 'Span', instr.ask("SENS:FREQ:SPAN?")

      instr.write("SENS:BWID:RES "+str(rbw))
      print 'RBW', instr.ask("SENS:BWID:RES?")
      
      swepts = 2*span/rbw # the ideal number of sweep points
      for tracelen in tracelenlist: 
        if (tracelen >= swepts): #take the higher trace len near to the ideal sweep points
          break
      instr.write("SENS:SWE:POIN "+str(tracelen))
      print 'Ideal sweep points', swepts, 'Sweep Points', instr.ask("SENS:SWE:POIN?")
      
      ##### Acquisition #####
      
      total_time = 0
      n = 0
      new_trace = zeros(tracelen)
      trace = zeros(tracelen)
      for samp in (arange(samp_num)+1):
        dt = time.time()

        while (sum(new_trace == trace) > 0): #take another trace while the current is the same as the last one
          n = n + 1
          trace = array(map(float, instr.ask("TRAC? TRACE1").split(',')))
          #print sum(new_trace == trace)
        new_trace = trace
        
        total_time = total_time + time.time() - dt
      
      print 'Total samples', n, 'Different samples', samp, 'AQT by instrument', instr.ask("SENS:SWE:TIME?"), 'AQT evaluated', total_time/samp, '\n'
        

