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
    # modify the prompt for the command that is executing to to show the start time
    C=$(($COLUMNS-24))
    echo -e "\033[1A\033[${C}C"

    # print the time the command was executed on the next line
    #print -nP "Command started @ %*\n"

    # start the command timer
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
    GIT_STATUS=`python ${gitstatus}`
}


git_super_status() {
	precmd_update_git_vars
	echo "$GIT_STATUS"
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
ZSH_THEME_GIT_PROMPT_NOCACHE=1

