
autoload -Uz compinit && compinit
autoload -U colors && colors

export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/Applications/MacVim.app/Contents/bin
export PATH=$PATH:/Users/$USER/jetbrains_scripts

export PROMPT="%{$fg[cyan]%}%n%{$reset_color%}|%{$fg[yellow]%}%~%{$reset_color%}$ "

