### Source Prezto. ###
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export LD_LIBRARY_PATH="/usr/local/lib"

### Set up the prezto prompt ###
#autoload -Uz promptinit
#promptinit
#prompt adam1

### OR zsh prompt ###
#autoload -Uz compinit -U promptinit
#compinit -C
#promptinit

### set walters prompt ###
#prompt walters

### set custom git prompt ###
source ~/.zsh/zshrc.sh

# Don't include the space at the end of the right prompt
# Requires zsh 5.0.5 +
#ZLE_RPROMPT_INDENT=0
#PROMPT='$(virtualenv_status)$(pwd_split)'
PROMPT='$(left_prompt)'
RPROMPT='$(git_super_status)%*'

TMOUT=60
TRAPALRM() {
    zle reset-prompt
}

#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt histignorealldups #sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Doesn't seem to work having this in the zprezto/modules/competion/init.zsh
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# load virtualenvwrapper for python (after custom PATHs)
venvwrap="virtualenvwrapper.sh"
/usr/bin/which -a $venvwrap
if [ $? -eq 0 ]; then
    venvwrap=`/usr/bin/which $venvwrap`
    source $venvwrap
fi

### ALIASES ###
# alias lsc='ls --color=auto'
lsp() { ls -alG "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}'; }
# alias ll='ls -alf --color=auto'
alias lsa='ls -A --color=auto'
alias la='ls -lA --color=auto'
# alias l='ls -CF --color=auto'
alias lsn='la -Al --group-directories-first --human-readable'
alias lsm='la -Altc --group-directories-first --human-readable'
alias lad="ls -lA --color=auto *.diff"
alias rmd="rm *.diff"
alias grep='grep --color=auto'
alias fgrep='fAgrep --color=auto'
alias egrep='egrep --color=auto'
alias x='exit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
### ---------------------------------------------------------------------------------------
### Folders
### ---------------------------------------------------------------------------------------
alias hm="cd ~/"
alias docs="cd ~/Documents"
alias down="cd ~/Downloads"
alias db="cd ~/Dropbox"
alias proj="cd ~/Dropbox/projects"
alias projects="cd ~/Dropbox/projects"

alias cnet="cd ~/workspace/cnet"
alias c1="cd ~/workspace/csr_main1"
alias c2="cd ~/workspace/csr_main2"
alias c3="cd ~/workspace/csr_main3"
alias d1="cd ~/workspace/dualrac1"
alias d2="cd ~/workspace/dualrac2"

### ---------------------------------------------------------------------------------------
### Git
### ---------------------------------------------------------------------------------------
alias gk="gitk --all &"
alias gti='git'
alias gt='git'

alias gs='git status'
alias gsn='git status -uno'
alias gst='git status -s'
alias gstno='git status -s -uno'

alias gsl='git stash list'
alias gss='git stash save'
alias gsp='git stash pop'

alias ga="git add"
alias gc="git commit"
alias gp="git pull"
alias gb="git branch -vv"
alias gm="git merge --no-ff"
alias gd="git diff --full-index"
alias -g si='submodule init'
alias -g su='submodule update'
alias -g st='status'

alias gitcount="git shortlog -sn --all"

### ---------------------------------------------------------------------------------------
### ATS
### ---------------------------------------------------------------------------------------
alias tn="python ~/scripts/testrigTelnet.py"
alias run="python runTest.py"

alias lilos="telnet 11.19.7.10 7003"
alias stitchs="telnet 11.19.7.10 7004"

alias timons="telnet 10.16.14.126 10034"
alias pumbaas="telnet 10.16.14.126 10036"

pingWithTime() {
    ping $1 | while read pong; do echo "$(date): $pong"; done
}
alias pingt=pingWithTime

spellInline() {
    echo $1 | aspell -a;
}
alias spell=spellInline
### ATS Testrig Serial Connection Aliases ###
alias arlos="telnet 11.19.9.10 9023"
alias spots="telnet 11.19.9.10 2022"
alias doofenshmirtzs="telnet 10.16.14.126 10076"
alias annas="telnet 10.16.14.125 10210"
alias elsas="telnet 10.16.14.125 10212"
alias arlos="telnet 11.19.9.10 9023"
alias timons="telnet 10.16.14.126 10034"
alias pumbaas="telnet 10.16.14.126 10036"
alias chuckies="telnet 11.19.6.10 6004"
alias megatrons="telnet 10.16.14.125 10032"
alias kylos="telnet 11.19.6.10 6018"
alias reys="telnet 11.19.6.10 6017"
alias spongebobs="telnet 10.16.14.125 10214"
alias patricks="telnet 10.16.14.125 10216"
alias bubbless="telnet 10.16.14.126 10060"
alias buttercups="telnet 10.16.14.126 10062"
alias tommys="telnet 11.19.6.10 6003"
alias rainbowdashs="telnet 10.16.14.125 10026"
alias spots="telnet 11.19.9.10 2022"
alias hans="telnet 11.19.9.10 9004"
alias chewies="telnet 11.19.9.10 9005"
alias pikachus="telnet 11.19.9.10 9003"
alias bungles="telnet 11.19.9.10 9020"
alias zippys="telnet 11.19.9.10 2021"
alias lilos="telnet 11.19.7.10 7003"
alias stitchs="telnet 11.19.7.10 7004"
alias jarjars="telnet 11.19.9.10 9006"
alias perrys="telnet 10.16.14.126 10074"
alias woodys="telnet 11.19.6.10 2007"
alias buzzs="telnet 11.19.6.10 2008"
alias woodys="telnet 11.19.6.10 6007"
alias buzzs="telnet 11.19.6.10 6008"
alias jessies="telnet 11.19.6.10 6009"
alias hamms="telnet 11.19.6.10 6010"
alias cats="telnet 10.16.14.126 10040"
alias dogs="telnet 10.16.14.126 10042"
alias rens="telnet 10.16.14.125 10204"
alias arlos="telnet 11.19.9.10 9023"
alias arlos="telnet 11.19.9.10 9022"
alias twilightsparkles="telnet 10.16.14.125 10024"
alias joys="telnet 11.19.9.10 9001"
alias bingbongs="telnet 11.19.9.10 9002"
alias jessies="telnet 11.19.6.10 2009"
alias hamms="telnet 11.19.6.10 2010"
alias moanas="telnet 11.19.7.10 7005"
alias mauis="telnet 11.19.7.10 7006"
alias woodys="telnet 11.19.6.10 6007"
alias buzzs="telnet 11.19.6.10 6008"
alias jessies="telnet 11.19.6.10 6009"
alias hamms="telnet 11.19.6.10 6010"
alias jessies="telnet 11.19.6.10 2009"
alias hamms="telnet 11.19.6.10 2010"
alias leos="telnet 10.16.14.126 10050"
alias bungles="telnet 11.19.9.10 9020"
alias poohs="telnet 10.16.14.126 10010"
alias tiggers="telnet 10.16.14.126 10012"
alias doras="telnet 10.16.14.125 10218"
alias walles="telnet 11.19.5.100 7924"
alias mowglis="telnet 11.19.7.10 7008"
alias baloos="telnet 11.19.7.10 7009"
alias zippys="telnet 11.19.9.10 2021"
alias marlins="telnet 10.16.14.126 10070"
alias ratchets="telnet 11.19.7.10 7001"
alias clanks="telnet 11.19.7.10 7002"
alias peppapigs="telnet 11.19.7.10 7007"
alias mikes="telnet 11.19.6.10 6001"
alias sulleys="telnet 11.19.6.10 6002"
alias starscreams="telnet 10.16.14.125 10030"
alias shaggys="telnet 10.16.14.126 10080"
alias scoobys="telnet 10.16.14.126 10082"
alias blues="telnet 10.16.14.126 10200"
alias magentas="telnet 10.16.14.126 10202"
alias stimpys="telnet 10.16.14.125 10206"
alias tinkerbells="telnet 10.16.14.125 10208"
alias simbas="telnet 10.16.14.126 10014"
alias nalas="telnet 10.16.14.126 10016"
### ATS Testrigs End ###
