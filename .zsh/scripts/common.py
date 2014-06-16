#!/usr/bin/env python
# -*- coding: UTF-8 -*-

RESET = '%{\e[0m%}'

# bash 8/16 colour codes
FG_DEFAULT = '39'
BG_DEFAULT = '49'

BLACK = '0'
RED = '1'
GREEN = '2'
YELLOW = '3'
BLUE = '4'
MAGENTA = '5'
CYAN = '6'
LGRAY = '7'
DGRAY = '8'
LRED = '9'
LGREEN = '10'
LYELLOW = '11'
LBLUE = '12'
LMAGENTA = '13'
LCYAN = '14'
WHITE = '15'

# 256 terminal colour codes
SOL_FG1 = '230'
SOL_FG2 = '255'
SOL_FOREGROUND = SOL_FG2

SOL_YELLOW = '178' # 136
SOL_ORANGE = '166'
SOL_RED = '124'
SOL_MAGENTA = '5'
SOL_VIOLET = '62'
SOL_BLUE = '33'
SOL_CYAN = '36'
SOL_GREEN = '100'


## Create a zsh prompt formatting string
# Content inside %{ %} is not used by zsh to calculate the prompt length.
def buildFormatStr(fg, bg):
    return '%{\e[0;' + fg + ';' + bg + 'm%}'

def format256ColourFg(colour):
    return '0;38;5;' + colour

def format256ColourBg(colour):
    return '48;5;' + colour

def buildThemeFormatString(fg, bg):
    return '%{\e[' + fg + 'm\e[' + bg + 'm%}'
