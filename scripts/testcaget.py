from epics import caget, caput
import time
from numpy import *

caput("DIG:RSFSL:Trace-Mon.SCAN",".005 second")
new_trace = zeros(int(caget("DIG:RSFSL:Trace-Mon.NELM")))
trace = zeros(int(caget("DIG:RSFSL:Trace-Mon.NELM")))


while (1):
	t = time.time()
	while (sum(new_trace == trace) > 0):
		trace = array(caget("DIG:RSFSL:Trace-Mon"))
	new_trace = trace
	print trace[0], time.time() - t

