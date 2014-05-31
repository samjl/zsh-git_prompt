#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import time
from common import *

hr = '{0}{1}'.format(buildFormatStr(FG_LGRAY, BG_BLACK), time.strftime("%H")) # FG_WHITE
min = '{0}{1}'.format(buildFormatStr(FG_LGRAY, BG_DGRAY), time.strftime("%M")) # FG_WHITE
sec = '{0}{1}'.format(buildFormatStr(FG_LGRAY, BG_BLACK), time.strftime("%S")) # FG_WHITE

print '{0}{1}{2}{3}'.format(hr, min, sec, RESET)

