#!/usr/bin/env python
''''small script to processs all media content in a folder and move it to a
other folder completly extract from archives'''
import os, sys, shutil
import tarfile

def unrar(package, destination):
    '''unrar rar image'''
    print "Unpacking %s to %s" % (package, destination)
    os.chdir(destination)
    pf = os.popen('unrar x %s' % (package))
    pf.readlines()
    pf.close()

def untar(package, destination):
    '''untar a tar archive'''
    print "Unpacking %s to %s" % (package, destination)
    if not tarfile.is_tarfile(package):
        return False
    tar = tarfile.open(package)
    tar.extractall(destination)
    return True

def _filter_files(item, extensionlist):
    '''filter for getting rar files'''
    if os.path.splitext(item.upper())[1] in extensionlist:
        return True
    return False


def _filter_rar_files(item):
    '''filter for getting rar files'''
    return _filter_files(item, ['.RAR'])

def _filter_bin_files(item):
    '''filter for getting bin files'''
    return _filter_files(item, ['.AVI','.IDX','.SUB'])

def _filter_tar_files(item):
    '''filter for getting tar files'''
    return _filter_files(item, ['.TAR', '.TGZ'])

def _filter_subs_list(item):
    '''filter sublist'''
    return item.upper().startswith('SUB')

def process_subs(folder, destination):
    files = set(os.listdir(folder))
    for rars in filter(_filter_rar_files, files):
        unrar(os.path.join(folder, rars), folder)
    for rars in files.difference(set(os.listdir(folder))):
        unrar(os.path.join(folder, rars), folder)
    for bins in filter(_filter_bin_files, os.listdir(folder)):
        shutil.move(os.path.join(folder, bins), destinationdir)
        
def process_folder(sourcefolder, destination):
    '''check if there are avi rar or tar files in this folder and process'''
    filesinfolder = os.listdir(sourcefolder)
    for tars in filter(_filter_tar_files, filesinfolder):
        fulltar = os.path.join(sourcefolder, tars)
        untar(fulltar, sourcefolder)
        os.remove(fulltar)
    for rars in filter(_filter_rar_files, filesinfolder):
        unrar(os.path.join(sourcefolder, rars), destination)
    for bins in filter(_filter_bin_files, filesinfolder):
        print "Moving %s to %s" % (bins, destination)
        shutil.move(os.path.join(sourcefolder, bins), os.path.join(destination, avis))
    for subs in filter(_filter_subs_list, filesinfolder):
        print "Moving %s to %s" % (subs, destination)
        shutil.move(os.path.join(sourcefolder, subs), os.path.join(destination, subs))


def proces_sourcedir(sourcedir, destinationdir):
    '''process all folder for media content'''
    for package in os.listdir(sourcedir):
        fullpackagename = os.path.join(sourcedir, package)
        packagedestination = os.path.join(destinationdir, package)
        if not os.path.exists(packagedestination):
            os.makedirs(packagedestination)
        for fileindir in os.listdir(fullpackagename):
            fullfilename = os.path.join(fullpackagename, fileindir)
            if os.path.isdir(fullfilename):
                if fileindir.upper().startswith('CD'):
                    process_folder(fullfilename, packagedestination)
        process_folder(fullpackagename, packagedestination)

def validate_arguments():
    '''validate passed arguments'''
    if len(sys.argv) != 3:
        print "Invalid parameters. "
        print "use:\n %s <sourcefolder> <destinationfolder>" % (sys.argv[0])
        sys.exit(1)
    sourcedir = sys.argv[1]
    destinationdir = sys.argv[2]
    if not os.path.isdir(sourcedir):
        print "Sourcedir %s should be a directory and should exist" % (sourcedir)
        sys.exit(1)
    if not os.path.isdir(destinationdir):
        print "Sourcedir %s should be a directory and should exist" % (destinationdir)
        sys.exit(1)
    return sourcedir, destinationdir

def main():
    ''''run main script'''
    sourcedir, destinationdir = validate_arguments()
    proces_sourcedir(sourcedir, destinationdir)

if __name__ == "__main__":
    main()
