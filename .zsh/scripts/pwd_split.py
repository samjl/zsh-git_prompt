#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import string, sys
from common import *

# Solarized theme
#fgColour = SOL_FOREGROUND
#bgOrder = [SOL_YELLOW, SOL_ORANGE, SOL_RED, SOL_MAGENTA, SOL_VIOLET, SOL_BLUE, SOL_CYAN, SOL_GREEN]
# Custom theme
fgColour = LGRAY
bgOrder = [DGRAY, GREEN, BLUE, MAGENTA, CYAN]


# LIMIT_CHARS - Whether to limit the number of characters in the directory string.
# If True limits to the number of characters specified by MAX_CHARS.
LIMIT_CHARS = False #True
MAX_CHARS = 30

# USE_CHEVRON - Whether to use the special chevron character or a normal slash to separate directories.
# Powerline symbols are required to display the chevron.
USE_CHEVRON = False
CHEVRON = '>' # '⮀'
SLASH = '/'

# Parameter passed in is the current PWD
original = sys.argv[1]
dirStr = original.replace('/home/slea1', '~')
dirStr = dirStr.replace('~/workspace/', 'w/')
dirStrLength = len(dirStr)
#print 'Number of characters: {0}'.format(dirStrLength) # if over x chars replace directories with ..
dirList = dirStr.split('/')
#print dirList
dirCount = len(dirList)
#print 'Number of directories: {0}'.format(dirCount)

if LIMIT_CHARS:
    dirRemoveIndex = 1
    while dirStrLength > MAX_CHARS:
        if dirRemoveIndex > dirCount - 2:  # Never shorten last dir in list
            break
        dirList[dirRemoveIndex] = '..'
        dirRemoveIndex += 1
        dirStrLength = 0
        for directory in dirList:
            dirStrLength += len(directory) + 1

newDirPrompt = ' '
# index = 0
dirsDone = 0
for index, direc in enumerate(dirList):
    index = index % len(bgOrder)
    arrowBgCol = bgOrder[index]
    if dirsDone == dirCount - 1:
        arrowBgCol = BG_DEFAULT #BG_BLACK
    else:
        arrowBgCol = format256ColourBg(arrowBgCol)
    if USE_CHEVRON:
        newDirPrompt = newDirPrompt + buildFormatStr(format256ColourFg(fgColour), format256ColourBg(bgOrder[index])) + direc + \
                       buildFormatStr(format256ColourFg(bgOrder[index]), arrowBgCol) + CHEVRON
    else:
        newDirPrompt = newDirPrompt + buildFormatStr(format256ColourFg(
            bgOrder[index]), BG_DEFAULT) + direc
        if dirsDone == dirCount - 1:
            newDirPrompt = newDirPrompt + RESET + " > "
        else:
            newDirPrompt = newDirPrompt + buildFormatStr(
                format256ColourFg(bgOrder[index]), BG_DEFAULT) + SLASH
    # index += 1
    dirsDone += 1
print(newDirPrompt)
