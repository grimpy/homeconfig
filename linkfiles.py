#!/usr/bin/env /usr/bin/python3
import os
import sys
import shutil
from optparse import OptionParser
parser = OptionParser()
parser.add_option("-r", "--root", dest="root", action="store_true", default=False,
                  help="Do root")
(options, args) = parser.parse_args()
repopath = os.path.abspath(os.path.dirname(sys.argv[0]))
fullpaths = []
linkfolders = ['.config/awesome', '.config/autostart', '.vim', '.urxvt', '.config/i3', '.config/i3blocks']
copydirs = ['etc/udev/rules.d', 'etc/systemd/system']
target = os.environ['HOME']

if options.root:
    if os.getuid() != 0:
        print("Use sudo not root")
        sys.exit(1)
    else:
        fullpaths.append(os.path.join(repopath, 'osconfig'))
        overlay = os.path.join(repopath, 'overlay', 'osconfig')
        if os.path.exists(overlay):
            fullpaths.append(os.path.join(repopath, 'osconfig'))
        target = "/"
else:
    fullpaths.append(os.path.join(repopath, 'homeconfig'))
    overlay = os.path.join(repopath, 'overlay', 'homeconfig')
    if os.path.exists(overlay):
        fullpaths.append(overlay)

#do folders defined in linkfolders
#cleanuppath
def cleanuppath(targetfolder):
    if os.path.islink(targetfolder):
        os.remove(targetfolder)
    elif os.path.exists(targetfolder):
        os.remove(targetfolder)
#createParentFolder
def createRecusiveFolder(folder):
    if not os.path.isdir(folder):
        os.makedirs(folder)

def createParentFolder(targetfolder):
    parenttarget = os.path.abspath(os.path.join(targetfolder, '..'))
    createRecusiveFolder(parenttarget)

for mypath in fullpaths:
    striplen = len(mypath) + 1
    for curdir, dirs, files in os.walk(mypath):
    #do normal files in root
        relativedir = curdir[striplen:]
        targetdir = os.path.join(target, relativedir)
        if relativedir not in linkfolders:
            print('Creating links files for folder', relativedir)
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
            os.symlink(curdir, targetdir)
            for dir_ in dirs[::-1]:
                dirs.remove(dir_)
