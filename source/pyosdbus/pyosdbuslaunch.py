#!/usr/bin/env python
import os,sys
import glib
from dbus.mainloop.glib import DBusGMainLoop
from pyosdbus import dbuspyosd

def main():
    dbus_loop = DBusGMainLoop(set_as_default=True)
    serv = dbuspyosd()
    loop = glib.MainLoop()
    loop.run()


if __name__ == "__main__":
    # do the UNIX double-fork magic, see Stevens' "Advanced 
    # Programming in the UNIX Environment" for details (ISBN 0201563177)
    try: 
        pid = os.fork() 
        if pid > 0:
            # exit first parent
            sys.exit(0) 
    except OSError, e: 
        print >>sys.stderr, "fork #1 failed: %d (%s)" % (e.errno, e.strerror) 
        sys.exit(1)

    # decouple from parent environment
    os.chdir("/") 
    os.setsid() 
    os.umask(0) 

    # do second fork
    try: 
        pid = os.fork() 
        if pid > 0:
            # exit from second parent, print eventual PID before
            print "Daemon PID %d" % pid 
            sys.exit(0) 
    except OSError, e: 
        print >>sys.stderr, "fork #2 failed: %d (%s)" % (e.errno, e.strerror) 
        sys.exit(1) 

    # start the daemon main loop
    main()
