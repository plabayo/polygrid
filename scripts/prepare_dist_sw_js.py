#!/usr/bin/env python

import os
import re


APP_DIST_DIR = "polygrid-app/dist"


any_app_filename = next(
    filename
    for filename in os.listdir(APP_DIST_DIR)
    if filename.startswith("polygrid-app-")
)

nes_studio_hash = re.search(r'-app-([a-zA-Z0-9]+)', any_app_filename)[1]

with open(f"{APP_DIST_DIR}/sw.js", "r") as f:
    data = f.read()
    data = data.replace('{{ POLYGRID_APP_HASH }}', nes_studio_hash)

with open(f"{APP_DIST_DIR}/sw.js", "w") as f:
    f.write(data)
