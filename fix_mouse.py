#!/usr/bin/env python3

# This script parses the html and javascript files in the current directory
# with the aim to allow mouse usage while the html file is in "fullscreen"
# mode. This script assumes that there is only one html and one js file
# present in the current directory and its usage is undefined otherwise.
# The changes made to the html and javascript files are sourced from 
# TODO: cite this.. 
#
# This script has been tested on Arch Linux.

import glob
import os

html = glob.glob("*.html")[0]
js = glob.glob("*.js")[0]

with open(html, 'r') as f:
    with open('out.html', 'w') as of:
        for line in f:
            line = line.replace("<div class=pico8_el onclick=\"Module.requestFullScreen(true, false);\">", "<div class=pico8_el onclick=\"Module.requestFullScreen(false, false);\">")
            of.write(line)

with open(js, 'r') as f:
    with open('out.js', 'w') as of:
        for line in f:
            line = line.replace("if(Browser.isFullScreen){Module[\"canvas\"].requestPointerLock();return 0}", "if(Browser.isFullScreen){/*Module[\"canvas\"].requestPointerLock();*/return 0}")
            of.write(line)

os.rename('out.html', html)
os.rename('out.js', js)
