# Return if not in interactive shell or already in tmux
[[ ($- != *i* ||  -n "$TMUX") ]] && return 


if tmux has-session -t main 2> /dev/null;
then
    tmux attach-session -t main
else
    tmux new-session -s main
fi
