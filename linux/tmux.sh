if [ $TERM != "screen" ]; then
	if tmux list-sessions; then
		tmux a
	else
		tmux
	fi
fi

