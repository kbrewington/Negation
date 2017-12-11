#!/usr/bin/env python3

# This script parses the html and javascript files in the html directory
# with the aim to allow mouse usage while the html file is in "fullscreen"
# mode. This script assumes that the html and js files are named negation.*
# The changes made to the html and javascript files are sourced from the
# following link: https://www.lexaloffle.com/bbs/?tid=28295

import glob
import os

def replace_string(_file, original, replace):
    with open(_file, 'r') as f:
        lines = f.readlines()
    with open(_file, 'w') as f:
        for line in lines:
            new_line = line.replace(original, replace)
            f.write(new_line)

if __name__ == "__main__":
    replace_string("../html/negation.html", "<div class=pico8_el onclick=\"Module.requestFullScreen(true, false);\">", "<div class=pico8_el onclick=\"Module.requestFullScreen(false, false);\">")
    replace_string("../html/negation.js", "if(Browser.isFullScreen){Module[\"canvas\"].requestPointerLock();return 0}", "if(Browser.isFullScreen){/*Module[\"canvas\"].requestPointerLock();*/return 0}")
