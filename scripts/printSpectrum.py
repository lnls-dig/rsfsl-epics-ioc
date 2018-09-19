from epics import caget
from matplotlib.pyplot import *

spec = caget('DIG:RSFSL:Trace-Mon')
plot(spec)
show()


