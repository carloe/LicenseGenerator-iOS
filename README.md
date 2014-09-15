#Settings Bundle License Generator
Recursively finds all LICENSE.* files in the input directory and generates a Settings.bundle friendly plist.

The script can help ensure that the license section of your app is always up to date. Since it searches recursively the script works well with cocoapods projects. It assumes that the parent directory of the LICENSE file is also the name of the library to be credited.

Inspired by JosephH and Sean's comments on [stackoverflow](http://stackoverflow.com/q/6428353).

##Using it as a build script


* Copy `credits.py` to the your project root
* Open your project, select your **Target** and select **Build Phases**
* Add a new **Run Script Phase** after target dependencies
* Add something like: `./credits.py -d $SRCROOT -o $SRCROOT/MyProj/Settings.bundle/Credits.plist`
* Build & profit

##License
MIT