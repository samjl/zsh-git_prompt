#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import string, sys
from common import *


bgOrder = [BG_DGRAY, BG_GREEN, BG_BLUE, BG_MAGENTA, BG_CYAN]
fgOrder = [FG_DGRAY, FG_GREEN, FG_BLUE, FG_MAGENTA, FG_CYAN]

# LIMIT_CHARS - Whether to limit the number of characters in the directory string.
# If True limits to the number of characters specified by MAX_CHARS.
LIMIT_CHARS = False #True
MAX_CHARS = 30

# USE_CHEVRON - Whether to use the special chevron character or a normal slash to separate directories.
# Powerline symbols are required to display the chevron.
USE_CHEVRON = True
CHEVRON = '⮀'
SLASH = '/'

## Create a zsh prompt formatting string
# Content inside %{ %} is not used by zsh to calculate the prompt length.
def buildFormatStr(fg, bg):
    return '%{\e[0;' + fg + ';' + bg + 'm%}'

# Parameter passed in is the current PWD
original = sys.argv[1]
dirStr = original.replace('/home/sam', '~')
dirStrLength = len(dirStr)
#print 'Number of characters: {0}'.format(dirStrLength) # if over x chars replace directories with ..
dirList = dirStr.split('/')
#print dirList
dirCount = len(dirList)
#print 'Number of directories: {0}'.format(dirCount)

if LIMIT_CHARS:
    dirRemoveIndex = 1
    while dirStrLength > MAX_CHARS:
        if dirRemoveIndex > dirCount - 2: # Never shorten last dir in list
            break
        dirList[dirRemoveIndex] = '..'
        dirRemoveIndex += 1
        dirStrLength = 0
        for directory in dirList:
            dirStrLength += len(directory) + 1

newDirPrompt = ''
index = 0
dirsDone = 0
for direc in dirList:
    if index == len(bgOrder):
        index = 0
    if index == len(bgOrder) - 1:
        arrowBgCol = bgOrder[0]
    else:
        arrowBgCol = bgOrder[index + 1]
    if dirsDone == dirCount - 1:
        arrowBgCol = BG_DEFAULT #BG_BLACK
    if USE_CHEVRON:
        newDirPrompt = newDirPrompt + buildFormatStr(FG_BLACK, bgOrder[index]) + direc + \
                       buildFormatStr(fgOrder[index], arrowBgCol) + CHEVRON
    else:
        newDirPrompt = newDirPrompt + buildFormatStr(FG_BLACK, bgOrder[index]) + direc + SLASH
    index += 1
    dirsDone += 1
newDirPrompt += RESET
print newDirPrompt
