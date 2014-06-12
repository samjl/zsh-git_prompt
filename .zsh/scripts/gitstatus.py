#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from __future__ import print_function
from common import *

# change those symbols to whatever you prefer
#symbols = {'ahead of': '↑', 'behind': '↓', 'prehash':':'}
symbols = {'ahead of': '⬆', 'behind': '⬇', 'prehash':':', 'diverged': '⭠'}
#symbols = {'ahead of': '▲', 'behind': '▼', 'prehash':':', 'diverged': '⭠'}

from subprocess import Popen, PIPE

import sys
gitsym = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
branch, error = gitsym.communicate()

error_string = error.decode('utf-8')

if 'fatal: Not a git repository' in error_string:
    sys.exit(0)

# git symbolic-ref HEAD should return "refs/heads/branch_name" so remove the first 12 chars
branch = branch.strip()[11:]

# modified files
res, err = Popen(['git','diff','--name-status'], stdout=PIPE, stderr=PIPE).communicate()
err_string = err.decode('utf-8')
if 'fatal' in err_string:
    sys.exit(0)
changed_files = [namestat[0] for namestat in res.splitlines()]

# staged files
staged_files = [namestat[0] for namestat in Popen(['git','diff', '--staged','--name-status'], stdout=PIPE).communicate()[0].splitlines()]

# status 'U' is unmerged files
# number of modified files 'M' status = all results - 'U' status files
nb_changed = len(changed_files) - changed_files.count('U')

# conflicts/unmerged files
nb_U = staged_files.count('U') # conflicts

# number of staged files = all results - 'U' status files
nb_staged = len(staged_files) - nb_U

# untracked files
nb_untracked = len(Popen(['git','ls-files','--others','--exclude-standard'],stdout=PIPE).communicate()[0].splitlines())

# TODO add git stash list

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
    # red
    #print('no branch')
    branch = symbols['prehash']+ Popen(['git','rev-parse','--short','HEAD'], stdout=PIPE).communicate()[0][:-1]
    detached = True
else: # on either a remote (tracked) or local only branch
    remote_name = Popen(['git','config','branch.%s.remote' % branch], stdout=PIPE).communicate()[0].strip()
    if remote_name:
        merge_name = Popen(['git','config','branch.%s.merge' % branch], stdout=PIPE).communicate()[0].strip()
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
        #print (revlist)
        # you can be ahead '>' and behind '<' if local version of tracked branch is on another branch
        behead = revlist.splitlines()
        ahead = len([x for x in behead if x[0]=='>'])
        #print (ahead)
        behind = len(behead) - ahead
        #print (behind)
        if behind != 0 and ahead != 0:
            remote += buildFormatStr(FG_RED, BG_DEFAULT) + '%s%s%s' % (behind, symbols['diverged'], ahead)
            #remote += buildFormatStr(FG_BLACK, BG_RED) + '%s%s%s' % (behind, symbols['diverged'], ahead)
        else:
            if behind:
                remote += buildFormatStr(FG_BLUE, BG_DEFAULT) + '%s%s' % (symbols['behind'], behind)
            if ahead:
                remote += buildFormatStr(FG_YELLOW, BG_DEFAULT) + '%s%s' % (symbols['ahead of'], ahead)

### BRANCH AND BRANCH STATUS ###
gitStatus = ''
if detached == True:
    gitStatus = buildFormatStr(FG_BLACK, BG_RED) + str(branch)
elif tracked == False:
    gitStatus = buildFormatStr(FG_GREEN, BG_DEFAULT) + str(branch)
else: # tracked == True and detac,hed == False
    gitStatus = buildFormatStr(FG_RED, BG_DEFAULT) + str(branch)
    #branchFormatted = buildFormatStr(FG_BLACK, BG_RED) + str(branch)
    if remote is not '':
        gitStatus += RESET + '❙' + remote # TODO is remote ever anything for untracked or no branch?
gitStatus += RESET + '❙'

### ADDED ### green
if nb_staged != 0:
    gitStatus += buildFormatStr(FG_GREEN, BG_DEFAULT) + '✚' + str(nb_staged) + RESET + '❙'

### MERGE CONFLICTS ###
if nb_U != 0:
    gitStatus += buildFormatStr(FG_RED, BG_DEFAULT) + '✘' + str(nb_U) + RESET + '❙'

### MODIFIED FILES ### red
if nb_changed != 0:
    gitStatus += buildFormatStr(FG_RED, BG_DEFAULT) + '✱' + str(nb_changed) + RESET + '❙'

### UNTRACKED ###
if nb_untracked != 0:
    gitStatus += buildFormatStr(FG_BLUE, BG_DEFAULT) + '⚡' + str(nb_untracked) + RESET + '❙'

### CLEAN REPO ###
if clean:
    gitStatus += buildFormatStr(FG_GREEN, BG_DEFAULT) + '✔' + RESET  + '❙' # make bold

### STASHES ###
# TODO add number of stahes

print(gitStatus)
