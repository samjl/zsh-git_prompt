#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from __future__ import print_function
import sys
from common import *
from subprocess import Popen, PIPE

# change those symbols to whatever you prefer
# '↑, ↓, ▲. ▼'
symbols = {'ahead of': '⬆', 'behind': '⬇', 'detached': ':', 'diverged': '⭠',
           "up-to-date": "✓"}
gitsym = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
branch, error = gitsym.communicate()
error_string = error.decode('utf-8')
if 'fatal: not a git repository' in error_string:
    sys.exit(0)

# git symbolic-ref HEAD should return "refs/heads/branch_name" so
# remove the first 12 chars
branch = branch.strip()[11:]

# modified files
cmd = ['git', 'diff', '--name-status']
res, err = Popen(cmd, stdout=PIPE, stderr=PIPE).communicate()
err_string = err.decode('utf-8')
if 'fatal' in err_string:
    sys.exit(0)
changed_files = [namestat[0] for namestat in res.splitlines()]

# staged files
cmd = ['git', 'diff', '--staged', '--name-status']
staged_files = [namestat[0] for namestat in Popen(cmd, stdout=PIPE).
                communicate()[0].splitlines()]

# status 'U' is unmerged files
# number of modified files 'M' status = all results - 'U' status files
nb_changed = len(changed_files) - changed_files.count('U')

# conflicts/unmerged files
nb_U = staged_files.count('U') # conflicts

# number of staged files = all results - 'U' status files
nb_staged = len(staged_files) - nb_U

# untracked files
cmd = ['git', 'ls-files', '--others', '--exclude-standard']
nb_untracked = len(Popen(cmd, stdout=PIPE).communicate()[0].splitlines())

# number of stashes
nb_stashes = len(Popen(['git','stash','list'],stdout=PIPE).communicate()[0].splitlines())

# check if the repo is clean
# i.e. no changed, staged, unmerged, untracked files
if not nb_changed and not nb_staged and not nb_U and not nb_untracked:
    clean = True
else:
    clean = False

remote = ''
detached = False
tracked = False
if not branch: # not on any branch
    #print('no branch')
    branch = symbols['detached'] + Popen(['git','rev-parse','--short',
                                         'HEAD'], stdout=PIPE).communicate()[0][:-1]
    detached = True
else: # on either a remote (tracked) or local only branch
    remote_name = Popen(['git','config','branch.%s.remote' % branch], stdout=PIPE).communicate()[0].strip()
    # print(remote_name)
    if remote_name:
        merge_name = Popen(['git','config','branch.%s.merge' % branch], stdout=PIPE).communicate()[0].strip()
        # print(merge_name)
        if remote_name == '.': # local
            #print('local branch')
            remote_ref = merge_name
        else:
            #print('remote branch')
            remote_ref = 'refs/remotes/%s/%s' % (remote_name, merge_name[11:])
            tracked = True
        revgit = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % remote_ref],stdout=PIPE, stderr=PIPE)
        revlist = revgit.communicate()[0]
        if revgit.poll(): # fallback to local
            revlist = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % merge_name],stdout=PIPE, stderr=PIPE).communicate()[0]
        # print (revlist)
        # you can be ahead '>' and behind '<' if local version of tracked branch is on another branch
        behead = revlist.splitlines()
        ahead = len([x for x in behead if x[0]=='>'])
        # print (ahead)
        behind = len(behead) - ahead
        # print (behind)
        if behind != 0 and ahead != 0:
            remote += buildFormatStr(format256ColourFg(BLACK),
                                     format256ColourBg(RED))\
                      + ' %s%s%s ' % (behind, symbols['diverged'], ahead)
        # else:
        elif behind:
            remote += buildFormatStr(format256ColourFg(BLACK),
                                     format256ColourBg(BLUE))\
                      + ' %s%s ' % (symbols['behind'], behind)
        elif ahead:
            remote += buildFormatStr(format256ColourFg(BLACK),
                                     format256ColourBg(YELLOW))\
                      + ' %s%s ' % (symbols['ahead of'], ahead)
        else: # ahead and behind are 0
            remote += buildFormatStr(format256ColourFg(BLACK),
                                     format256ColourBg(GREEN))\
                      + ' %s ' % (symbols['up-to-date'])

### BRANCH AND BRANCH STATUS ###
gitStatus = ''
if detached:
    gitStatus = buildFormatStr(format256ColourFg(BLACK),
                               format256ColourBg(RED)) + " {} ".format(branch)
elif not tracked:
    gitStatus = buildFormatStr(format256ColourFg(BLACK),
                               format256ColourBg(GREEN))\
                + " {} ".format(branch)
else: # tracked == True and detac,hed == False
    if remote is not '':
        gitStatus += remote + RESET
    gitStatus += buildFormatStr(format256ColourFg(BLACK), format256ColourBg(
        RED)) + " " + str(branch) + " "
# gitStatus += RESET + '❙'
gitStatus += RESET

### ADDED ### green
if nb_staged != 0:
    gitStatus += buildFormatStr(format256ColourFg(BLACK),
                                format256ColourBg(GREEN))\
                 + ' ✚{} '.format(nb_staged) + RESET

### MERGE CONFLICTS ###
if nb_U != 0:
    gitStatus += buildFormatStr(format256ColourFg(RED), BG_DEFAULT) + '✘' + str(nb_U) + RESET + '❙'

### MODIFIED FILES ### red
if nb_changed != 0:
    gitStatus += buildFormatStr(format256ColourFg(BLACK),
                                format256ColourBg(RED))\
                 + ' ✱{} '.format(nb_changed) + RESET

### UNTRACKED ###
if nb_untracked != 0:
    gitStatus += buildFormatStr(format256ColourFg(BLACK),
                                format256ColourBg(BLUE))\
                 + ' ⚡{} '.format(nb_untracked) + RESET

### CLEAN REPO ###
# if clean:
#     gitStatus += buildFormatStr(format256ColourFg(GREEN), BG_DEFAULT) + '✔' + RESET  + '❙' # make bold

### STASHES ###
if nb_stashes != 0:
    gitStatus += buildFormatStr(format256ColourFg(BLACK),
                                format256ColourBg(LGRAY))\
                 + ' ➦{} '.format(nb_stashes) + RESET

gitStatus += RESET + " "
print(gitStatus)
