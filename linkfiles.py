#!/usr/bin/env /usr/bin/python2
import os
import sys
import shutil
from optparse import OptionParser
parser = OptionParser()
parser.add_option("-r", "--root", dest="root", action="store_true", default=False,
                  help="Do root")
(options, args) = parser.parse_args()
fullpath = os.path.abspath(os.path.dirname(sys.argv[0]))
linkfolders = ['.config/awesome', '.config/autostart', '.zsh.d', '.ssh', '.vim', '.urxvt', '.config/i3', '.config/i3blocks']
copydirs = ['etc/udev/rules.d']
target = os.environ['HOME']

if options.root:
    if os.getuid() != 0:
        print "Use sudo not root"
        sys.exit(1)
    else:
        fullpath = os.path.join(fullpath, 'osconfig')
        target = "/"
else:
    fullpath = os.path.join(fullpath, 'homeconfig')

striplen = len(fullpath) + 1
#do folders defined in linkfolders
#cleanuppath
def cleanuppath(targetfolder):
    if os.path.islink(targetfolder):
        os.remove(targetfolder)
    elif os.path.isdir(targetfolder):
        shutil.rmtree(targetfolder)
    elif os.path.exists(targetfolder):
        os.remove(targetfolder)
#createParentFolder
def createRecusiveFolder(folder):
    if not os.path.isdir(folder):
        os.makedirs(folder)

def createParentFolder(targetfolder):
    parenttarget = os.path.abspath(os.path.join(targetfolder, '..'))
    createRecusiveFolder(parenttarget)

for curdir, dirs, files in os.walk(fullpath):
#do normal files in root
    relativedir = curdir[striplen:]
    targetdir = os.path.join(target, relativedir)
    if relativedir not in linkfolders:
        print 'Creating links files for folder', relativedir
        createRecusiveFolder(targetdir)
        for file_ in files:
            targetfile = os.path.join(targetdir, file_)
            sourcefile = os.path.join(curdir, file_)
            cleanuppath(targetfile)
            if relativedir in copydirs:
                shutil.copy(sourcefile, targetfile)
            else:
                os.symlink(sourcefile, targetfile)
    else:
        cleanuppath(targetdir)
        createParentFolder(targetdir)
        print 'Link dir', relativedir
        os.symlink(curdir, targetdir)
        for dir_ in dirs[::-1]:
            dirs.remove(dir_)
