# git aliases
alias gs="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gca="git commit -am"
alias gl="git log --oneline"
alias gp="git push"
alias gd="git diff"
alias gpl=git\ pull
alias gcd1=git\ clone\ --depth=1
alias gc=git\ checkout

alias f=exa
alias a=bat
alias py=python3
alias paiton=python3
alias where=which
alias docs=rustup\ doc\ --std
alias start=xdg-open
alias paithon=python3

alias refreshenv=source\ $HOME/.bashrc

alias refreshenv="source $HOME/.bashrc"

export GOPATH=$HOME/dev/go

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/dev/scripts
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$PATH:$HOME/jetbrains_shell_scripts

PS1="\[\e[36m\]\u\[\e[m\]|\[\e[33m\]\w\[\e[m\]\\$ "

export BAT_THEME=Solarized\ \(dark\)

#source "${BASH_SOURCE%/*}/ls_after_cd.sh"

eval "$(zoxide init bash)"

if [ $TERM != "screen" ]; then
	if tmux list-sessions; then
		tmux a
	else
		tmux
	fi
fi

