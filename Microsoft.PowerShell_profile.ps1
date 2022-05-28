#!/usr/local/bin/pwsh

function Prompt {
	$username = $env:USER
	Write-Host "$username" -NoNewLine -ForegroundColor 3
	Write-Host "|" -NoNewLine

	[string]$currentDir = (Get-Location).Path
	if ($currentDir.StartsWith($HOME)) {
		$currentDir = "~" + $currentDir.Substring($HOME.Length)
	}

	Write-Host "$($currentDir)" -NoNewLine -ForegroundColor 6
	Write-Host "$" -NoNewLine

	" "
}

function RefreshEnv {
	& $PROFILE
}

$env:PATH += "/opt/homebrew/opt/llvm/bin:$HOME/.cargo/bin:/usr/local/microsoft/powershell/7:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/dev/scripts:$HOME/dev/go/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/jetbrains_shell_scripts:/opt/homebrew/bin:/Applications/MacVim.app/Contents/bin:$HOME/jetbrains_scripts:$HOME/dev/repos/binaryen/bin:$HOME/.local/bin:$HOME/dev/scripts:$HOME/dev/go/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/jetbrains_shell_scripts:/opt/homebrew/bin:/Applications/MacVim.app/Contents/bin:$HOME/jetbrains_scripts:$HOME/dev/repos/binaryen/bin"

if ($env:BAT_THEME -eq $null) {
	$env:BAT_THEME = "Solarized (dark)"
}

function Invoke-GitStatus {
	param ([string[]]$objects)
	git status $objects
}

function Invoke-GitDiff {
	param ([string[]]$objects)
	git diff $objects
}

function Invoke-GitCommit {
	param ([string[]]$objects)
	git commit -m $objects
}

function Invoke-GitCommitAll {
	param ([string[]]$objects)
	git commit -am $objects
}

function Invoke-GitPull {
	param ([string[]]$objects)
	git pull $objects
}

function Invoke-GitPush {
	param ([string[]]$objects)
	git push $objects
}

function Invoke-GitAdd {
	param ([string[]]$objects)
	git add $objects
}

function Invoke-GitCloneDepth1 {
	param ([string[]]$objects)
	git clone --depth=1 $objects
}

function Invoke-GitLogOneline {
	param ([string[]]$objects)
	git log --oneline $objects
}

Set-Alias -Name f -Value "exa"
Set-Alias -Name a -Value "bat"
Set-Alias -Name paiton -Value "python3"
Set-Alias -Option AllScope -Force -Name "gs" -Value Invoke-GitStatus
Set-Alias -Option AllScope -Force -Name "gd" -Value Invoke-GitDiff
Set-Alias -Option AllScope -Force -Name "gcm" -Value Invoke-GitCommit
Set-Alias -Option AllScope -Force -Name "gca" -Value Invoke-GitCommitAll
Set-Alias -Option AllScope -Force -Name "gpl" -Value Invoke-GitPull
Set-Alias -Option AllScope -Force -Name "gp" -Value Invoke-GitPush
Set-Alias -Option AllScope -Force -Name "ga" -Value Invoke-GitAdd
Set-Alias -Option AllScope -Force -Name "gcd1" -Value Invoke-GitCloneDepth1
Set-Alias -Option AllScope -Force -Name "gl" -Value Invoke-GitLogOneline

function Get-CommandSource {
	param (
		$CommandName
	)

	$Command = Get-Command -ErrorAction Stop $CommandName 

	while ($Command.CommandType -eq [System.Management.Automation.CommandTypes]::Alias) {
		$Command = Get-Command $Command.Definition
	}

	return $Command.Source
}

Set-Alias -Option AllScope -Force -Name "gcmd" -Value Get-CommandSource

# if ($env:TMUX -eq $null) {
# 	tmux a
# 	if (!$?) {
# 		tmux
# 	}
# }

Import-Module posh-git

$env:PATH += ":$HOME/.fnm"

if ((Get-Command -ErrorAction SilentlyContinue fnm) -ne $null) {
	fnm env --use-on-cd | Out-String | Invoke-Expression
	$HasFnm = $true
}

$env:LANGUAGE = "en_US"

function Set-LocationWithBat {
	param (
		$Path
	)

	Set-Location $Path

	if ($HasFnm) {
		Set-FnmOnLoad
	}

	exa
}

Remove-Item alias:\cd
New-Alias cd Set-LocationWithBat
