#!/usr/bin/python
# coding: utf-8

"""
    Recursively searches the input directory for 'LICENSE.*' files and compiles
    them into a Settings.bundle friendly plist. Inspired by JosephH
    and Sean's comments on stackoverflow: http://stackoverflow.com/q/6428353

    :usage: ./credits.py -s project/ -o project/Settings.bundle/Credits.plist

    :author: Carlo Eugster (http://carlo.io)
    :license: MIT, see LICENSE for more details.
"""

import os
import sys
import plistlib
import re
import codecs
from optparse import OptionParser
from optparse import Option, OptionValueError
from copy import deepcopy

VERSION = '0.3'
PROG = os.path.basename(os.path.splitext(__file__)[0])
DESCRIPTION = """Recursively searches the input directory for 'LICENSE.*' 
files and compiles them into a Settings.bundle friendly plist. Inspired by 
JosephH and Sean's comments on stackoverflow: http://stackoverflow.com/q/6428353"""


class MultipleOption(Option):
    ACTIONS = Option.ACTIONS + ("extend",)
    STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
    TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
    ALWAYS_TYPED_ACTIONS = Option.ALWAYS_TYPED_ACTIONS + ("extend",)

    def take_action(self, action, dest, opt, value, values, parser):
        if action == "extend":
            values.ensure_value(dest, []).append(value)
        else:
            Option.take_action(self, action, dest, opt, value, values, parser)


def main(argv):
    def exclude_callback(option, _, value, option_parser):
        setattr(option_parser.values, option.dest, value.split(','))

    parser = OptionParser(option_class=MultipleOption,
                          usage='usage: %prog -s source_path -o output_plist -e [exclude_paths]',
                          version='%s %s' % (PROG, VERSION),
                          description=DESCRIPTION)
    parser.add_option('-s', '--source',
                      type="string",
                      dest='input_path',
                      metavar='source_path',
                      help='source directory to search for licenses')
    parser.add_option('-o', '--output-plist',
                      type="string",
                      dest='output_file',
                      metavar='output_plist',
                      help='path to the plist to be generated')
    parser.add_option('-e', '--exclude',
                      action="callback", type="string",
                      dest='excludes',
                      metavar='path1, ...',
                      help='comma separated list of paths to be excluded',
                      callback=exclude_callback)
    if len(sys.argv) == 1:
        parser.parse_args(['--help'])

    options, args = parser.parse_args()

    if not os.path.isdir(options.input_path):
        print("Error: Invalid source path: %s" % options.input_path)
        sys.exit(2)

    if not options.output_file.endswith('.plist'):
        print("Error: Outputfile must end in .plist")
        sys.exit(2)

    plist = plist_from_dir(options.input_path, options.excludes)
    plistlib.writePlist(plist, options.output_file)
    return 0


def plist_from_dir(directory, excludes):
    """
    Recursively search 'dir' to generates plist objects from LICENSE files.
    """
    plist = {'PreferenceSpecifiers': [], 'StringsTable': 'Acknowledgements'}
    os.chdir(sys.path[0])
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.startswith("LICENSE"):
                plist_path = os.path.join(root, file)
                if not exclude_path(plist_path, excludes):
                    license_dict = plist_from_file(plist_path)
                    plist['PreferenceSpecifiers'].append(license_dict)
    return plist


def plist_from_file(path):
    """
    Returns a plist representation of the file at 'path'. Uses the name of the
    parent folder for the title property.
    """
    base_group = {'Type': 'PSGroupSpecifier', 'FooterText': '', 'Title': ''}
    current_file = open(path, 'r')
    group = deepcopy(base_group)
    title = path.split("/")[-2]
    group['Title'] = unicode(title, 'utf-8')
    src_body = current_file.read()
    body = ""
    for match in re.finditer(r'(?s)((?:[^\n][\n]?)+)', src_body):
        body = body + re.sub("(\\n)", " ", match.group()) + "\n\n"
    body = unicode(body, 'utf-8')
    group['FooterText'] = rchop(body, " \n\n")
    return group


def exclude_path(path, excludes):
    if excludes is None:
        return False
    for pattern in excludes:
        if re.search(pattern.strip(), path, re.S) is not None:
            return True
    return False


def rchop(str, ending):
    if str.endswith(ending):
        return str[:-len(ending)]
    return str


if __name__ == "__main__":
    main(sys.argv[1:])
