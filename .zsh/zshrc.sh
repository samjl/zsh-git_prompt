# To install source this file from your .zshrc file

# Scripts directory
export __SCRIPTS_DIR=~/.zsh/scripts


# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

add-zsh-hook preexec preexec_start_cmd_timer
add-zsh-hook precmd precmd_stop_cmd_timer

note_remind=0
note_ignore="yes"
note_command="?"

function preexec_start_cmd_timer() {
    if [ "x$TTY" != "x" ]; then
        note_remind="$SECONDS"
        note_ignore=""
        note_command="$2"
    fi
}

function precmd_stop_cmd_timer() {
    local xx
    if [ "x$TTY" != "x" ]; then
        if [ "x$note_ignore" = "x" ]; then
            note_ignore="yes"
            xx=$(($SECONDS-$note_remind))
            if [ $xx -gt 10 ]; then
                if [ $TTYIDLE -gt 10 ]; then
                    note_report $xx
                fi
            fi
        fi
    fi
}

function note_report()
{
    #echo ""
    echo "Command completed in $1 seconds"
}

## Function definitions
function preexec_update_git_vars() {
    case "$2" in
        git*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ -n "$ZSH_THEME_GIT_PROMPT_NOCACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function chpwd_update_git_vars() {
    update_current_git_vars
}

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__SCRIPTS_DIR/gitstatus.py"
    _GIT_STATUS=`python ${gitstatus}`
    __CURRENT_GIT_STATUS=("${(@f)_GIT_STATUS}")
	GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
	GIT_REMOTE=$__CURRENT_GIT_STATUS[2]
	GIT_STAGED=$__CURRENT_GIT_STATUS[3]
	GIT_CONFLICTS=$__CURRENT_GIT_STATUS[4]
	GIT_CHANGED=$__CURRENT_GIT_STATUS[5]
	GIT_UNTRACKED=$__CURRENT_GIT_STATUS[6]
	GIT_CLEAN=$__CURRENT_GIT_STATUS[7]
}


git_super_status() {
	precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  #STATUS="($GIT_BRANCH"
	  #STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
	  STATUS="$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
	  if [ -n "$GIT_REMOTE" ]; then
		  #STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE%{${reset_color}%}"
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE%{${reset_color}%}"
	  fi
	  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED%{${reset_color}%}"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
	  echo "$STATUS"
	fi
}

pwd_split() {
    #echo "$(pwd)"
    local original_pwd="$(pwd)"
    #echo "$original_pwd"
    local new_pwd="$__SCRIPTS_DIR/pwd_split.py"
    SPLIT_PWD=`python ${new_pwd} ${original_pwd}`
    echo "$SPLIT_PWD"
}

colored_time() {
    local cmd="$__SCRIPTS_DIR/time_format.py"
    TIME=`python ${cmd}`
    echo "$TIME"
}

# Default values for the appearance of the prompt. Configure at will.
#ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_PREFIX="⭠ "
#ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SUFFIX="❙"
#ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_SEPARATOR="❙"
#ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
#ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}✚"
#ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}✘"
#ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}✚"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}✱"
ZSH_THEME_GIT_PROMPT_REMOTE=""
#ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_UNTRACKED="⚡"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"
ZSH_THEME_GIT_PROMPT_NOCACHE=1

