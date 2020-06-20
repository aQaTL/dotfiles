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
alias where=which
alias docs=rustup\ doc\ --std

alias refreshenv=source\ $HOME/.bashrc

PATH="$PATH:$HOME/.local/bin"

PS1="\u|\[\e[33m\]\w\[\e[m\]\\$ "

#export CARGO_TARGET_DIR=$HOME/cargo_target
