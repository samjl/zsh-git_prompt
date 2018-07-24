#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
from common import *

if 'VIRTUAL_ENV' in os.environ:
    full_path = os.environ['VIRTUAL_ENV']
    env = full_path.split("/")[-1]
    # env_formatted = buildFormatStr(format256ColourFg(RED), BG_DEFAULT) + env + "::" + RESET
    # The snake unicode character takes up 2 char positions to specify its
    # length, see: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
    env_formatted = buildFormatStr(format256ColourFg(BLACK), format256ColourBg(
        BLUE)) + " %2{🐍%} " + env + " " + RESET
    print(env_formatted)
else:
    env_formatted = buildFormatStr(format256ColourFg(RED), BG_DEFAULT) + "❌" + RESET
    print(env_formatted)
