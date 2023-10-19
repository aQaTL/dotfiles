alias v = nvim

alias f = ls
alias ff = exa
alias a = bat
alias paiton = python3
alias clpy = cargo clippy --all-targets
alias cf = cargo fmt
alias gs = git status
alias gd = git diff
alias gcm = git commit -m 
alias gca = git commit -am
alias gpl = git pull
alias gp = git push
alias ga = git add
alias gcd1 = git clone --depth=1
alias gl = git log --online
alias rmrf = rm -rf
alias v = nvim
alias vv = neovide

def prompt [] {
	mut user = ""
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
			$user = $env.USERNAME
        } else {
            $home = $env.HOME
			$user = $env.USER
        }
    }

    let pwd = ([
        ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

	$"(ansi cyan)($user)|(ansi yellow)($pwd)(ansi reset)"
}

$env.PROMPT_COMMAND = {|| prompt }
$env.PROMPT_INDICATOR = {|| "$ " }

$env.config.cursor_shape.emacs = "block"
