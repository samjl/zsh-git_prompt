### Source Prezto. ###
#if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
#fi

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

#PROMPT='%B%#%b '
#PROMPT='%{$bg[green]%}%{$fg[black]%}$(pwd_split)%{$reset_color%} %B%#%b '
#local parse_special=%{$(pwd_split)}
PROMPT='$(pwd_split)'
#PROMPT='%{$parse_special}'
#RPROMPT='%{$fg[green]%}%~%{$reset_color%}$(git_super_status) %*'
#RPROMPT='$(git_super_status)%*'
RPROMPT='$(git_super_status)$(colored_time)'
#RPROMPT='$(git_super_status) $(date +%T)'

TMOUT=1
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

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

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
