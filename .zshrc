### Source Prezto. ###
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

### Set up the prezto prompt ###
#autoload -Uz promptinit
#promptinit
#prompt adam1

### OR zsh prompt ###
autoload -Uz compinit -U promptinit
compinit -C
promptinit

### set walters prompt ###
#prompt walters

### set custom git prompt ###
source ~/.zsh/zshrc.sh

# Don't include the space at the end of the right prompt
# Requires zsh 5.0.5 +
#ZLE_RPROMPT_INDENT=0
PROMPT='$(pwd_split)'
RPROMPT='$(git_super_status)%*'

TMOUT=60
TRAPALRM() {
    zle reset-prompt
}

#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Doesn't seem to work having this in the zprezto/modules/competion/init.zsh
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### ALIASES ###
alias ls='ls --color=auto'
alias ll='ls -alf --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
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

### ---------------------------------------------------------------------------------------
### Git
### ---------------------------------------------------------------------------------------
alias gk="gitk --all"
alias gti='git'
alias gt='git'
alias gs='git status'
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gb="git branch"
alias -g si='submodule init'
alias -g su='submodule update'
alias -g st='status'
