import struct
import glob
import sys

devices = dict()
for idx, dev in enumerate(glob.glob("/dev/input/*")):
    print "%2d: %s" % (idx+1, dev)
    devices[str(idx+1)] = dev

print "Make your choice"
nr = sys.stdin.readline()[:-1]
if nr not in devices:
    raise RuntimeError("Invalid choice")
dev = devices[nr]
f = open(dev)
format = "llHHi"

#struct input_event {
#    struct timeval time;
#    unsigned short type;
#    unsigned short code;
#    unsigned int value;
#};

KEY_TYPE = 1

s = struct.calcsize(format)
print s
while True:
    data = f.read(s)
    time1, time2, evtype, evcode, evvalue = struct.unpack(format, data)
    print evcode, evvalue
