#!/usr/bin/python
# coding: utf-8

"""
    Recursively searches the input directory for 'LICENSE.*' files and compiles
    them into a Settings.bundle friendly plist. Inspired by JosephH
    and Sean's comments on stackoverflow: http://stackoverflow.com/q/6428353

    :usage: ./credits.py -d project/ -o project/Settings.bundle/Credits.plist

    :author: Carlo Eugster (http://carlo.io)
    :license: MIT, see LICENSE for more details.
"""

import os
import sys
import plistlib
import re
import codecs
import getopt
from copy import deepcopy

def main(argv):
    outputfile = None
    inputdir = None
    try:
        opts, args = getopt.getopt(argv,"hd:o:",["idir=","ofile="])
    except getopt.GetoptError:
        printHelp(1)
    for opt, arg in opts:
        if opt == '-h':
            printHelp(0)
        elif opt in ("-d", "--dir"):
            inputdir = arg
        elif opt in ("-o", "--out"):
            outputfile = arg

    if(outputfile == None or inputdir == None):
        printHelp(2)

    if(not outputfile.endswith('.plist')):
        print "Error: Outputfile must end in .plist"
        sys.exit(2)

    if(not os.path.isdir(inputdir)):
        print "Error: Input directory does not exist."
        sys.exit(2)

    plist = plistFromDir(inputdir)
    plistlib.writePlist(plist,outputfile)
    return 0

def printHelp(code):
    print 'Suntax:'
    print '\tcredits.py -d <sourcepath> -o <outputfile>'
    sys.exit(code)

def plistFromDir(dir):
    """
    Recursilvely search 'dir' to generates plist objects from LICENSE files.
    """
    plist = {'PreferenceSpecifiers': [], 'StringsTable': 'Acknowledgements'}
    os.chdir(sys.path[0])
    for root, dirs, files in os.walk(dir):
        for file in files:
            if file.startswith("LICENSE"):
                license = plistFromFile(os.path.join(root, file))
                plist['PreferenceSpecifiers'].append(license)
    return plist

def plistFromFile(path):
    """
    Returns a plist representation of the file at 'path'. Uses the name of the
    paremt folder for the title property.
    """
    base_group = {'Type': 'PSGroupSpecifier', 'FooterText': '', 'Title': ''}
    current_file = open(path, 'r')
    group = deepcopy(base_group)
    title = path.split("/")[-2]
    group['Title'] = unicode(title, 'utf-8')
    srcBody = current_file.read()
    body = ""
    for match in re.finditer(r'(?s)((?:[^\n][\n]?)+)', srcBody):
        body = body + re.sub("(\\n)", " ", match.group()) + "\n\n"
    body = unicode(body, 'utf-8')
    group['FooterText'] = rchop(body, " \n\n")
    return group

def rchop(str, ending):
    if str.endswith(ending):
        return str[:-len(ending)]
    return str

if __name__ == "__main__":
    main(sys.argv[1:])