#!/usr/bin/env python
# -*- coding: UTF-8 -*-

RESET = '%{\e[0m%}'

# bash 8/16 colour codes
FG_DEFAULT = '39'
FG_BLACK = '30'
FG_RED = '31'
FG_GREEN = '32'
FG_YELLOW = '33'
FG_BLUE = '34'
FG_MAGENTA = '35'
FG_CYAN = '36'
FG_LGRAY = '37'
FG_DGRAY = '90'
FG_LRED = '91'
FG_LGREEN = '92'
FG_LYELLOW = '93'
FG_LBLUE = '94'
FG_LMAGENTA = '95'
FG_LCYAN = '96'
FG_WHITE = '97'

BG_DEFAULT = '49'
BG_BLACK = '40'
BG_RED = '41'
BG_GREEN = '42'
BG_YELLOW = '43'
BG_BLUE = '44'
BG_MAGENTA = '45'
BG_CYAN = '46'
BG_LGRAY = '47'
BG_DGRAY = '100'
BG_LRED = '101'
BG_LGREEN = '102'
BG_LYELLOW = '103'
BG_LBLUE = '104'
BG_LMAGENTA = '105'
BG_LCYAN = '106'
BG_WHITE = '107'

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
