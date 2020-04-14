#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Markdown TOC generator.
"""

import os

readme = open("TOC.md", "w")
readme.write("# TOC\n")

for root, dirs, files in os.walk("."):
    files = [f for f in files if not (f[0] == '.' or f == os.path.basename(__file__))]
    dirs[:] = [d for d in dirs if not d[0] == '.']

    for file in files:
        readme.write("\n- [" + os.path.splitext(file)[0] + "](" + root + "/" + file + ")")

readme.close()
