#!/bin/bash
LICENSE_FILE_PATHS=`find Pods -iname "license*" -type f | grep -v "/LicensesViewController/LicensesViewController" | grep -v "xcscheme"`
SAVE_PATHS="Licenses"
echo "Import Cocoapods licenses files into folder..."
for LICENSE_PATH in $LICENSE_FILE_PATHS
do
	SAVE_PATH=$SAVE_PATHS"/"`echo $LICENSE_PATH | sed "s/^Pods\///g" | sed "s/\.md$//g"`
	FOLDER=`echo $SAVE_PATH | sed "s/\/[Ll][Ii][Cc][Ee][Nn][Ss][Ee]$//g"`
	mkdir -p $FOLDER
	cp $LICENSE_PATH $SAVE_PATH
done
echo "Done."