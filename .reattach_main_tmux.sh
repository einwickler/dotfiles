#!/bin/bash

main_session_name=main
session_info=$(tmux list-sessions)

# Checking if main session exists
if tmux has-session -t $main_session_name 2> /dev/null;
then
    unat_sessions=$(echo "$session_info" | grep -v " (attached)$")
    main_session_unat=$(echo "$unat_sessions" | grep "^$main_session_name: ")

    # Checking if main session is unattached
    if [[ $main_session_unat ]]; then
        echo "Attaching to main: '${main_session_unat}'"
        tmux attach-session -t $main_session_name
    else
        ses_to_attach=$(echo "$unat_sessions" | cut -d: -f1 | head -n1)

        # Check if any other unattached session is available
        if [[ $ses_to_attach ]]; then
            echo "Attaching to session: '${ses_to_attach}'"
            tmux attach-session -t $ses_to_attach    
        else
            echo "Creating new session '${ses_to_attach}'"
            tmux new-session
        fi
    fi
else
    "Creating new main session: ${main_session_name}"
    tmux new-session -s $main_session_name
fi

