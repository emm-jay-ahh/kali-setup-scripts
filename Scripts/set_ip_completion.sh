#!/bin/bash

_set_ip_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}   # Current word user is typing
    COMPREPLY=()                          # Array variable storing completions

    if [[ $COMP_CWORD == 1 ]]; then
        # If we're completing the first argument, suggest network interfaces
        local interfaces=$(ip link show | awk -F': ' '{if (NR>1) print $2}' | awk '{print $1}')
        COMPREPLY=($(compgen -W "$interfaces" -- $cur))
    fi

    return 0
}

# Apply completion to both the script and the alias
complete -F _set_ip_completion $HOME/Scripts/set_ip.sh
complete -F _set_ip_completion myipexport
