#!/usr/local/bin/pwsh

function Prompt {
	[string]$currentDir = (Get-Location).Path
	if ($currentDir.StartsWith($HOME)) {
		$currentDir = "~" + $currentDir.Substring($HOME.Length)
	}
	
	if ((Test-Path Env:\SSH_CLIENT) -or (Test-Path Env:\SSH_TTY)) {
		$hostname_ = $global:HOSTNAME
	} else {
		$hostname_ = ""
	}
	
	if ($IsRoot) {
		$userSign = "# "
	} else {
		$userSign = ""
	}

	if ($IsWindows -and (Test-Path Env:\WT_SESSION) -or $env:TERM -match "xterm|rxvt") {
		Write-Host "`e]0;${userSign}${hostname_} ${currentDir}`a" -NoNewLine
	}

	$usernameColor = ([System.Environment]::GetEnvironmentVariable("SSH_CONNECTION") -eq $null) `
		? "3" `
		: "1"

	Write-Host "`e]133;A`a" -NoNewline

	Write-Host "${global:username}" -NoNewLine -ForegroundColor $usernameColor
	Write-Host "|" -NoNewLine

	Write-Host "$($currentDir)" -NoNewLine -ForegroundColor 6
	Write-Host "$" -NoNewLine

	Write-Host "`e]133;B`a" -NoNewline

	" "
}

function RefreshEnv {
	& $PROFILE
}

$global:HOSTNAME="$(hostname)"

$PathSep = [IO.Path]::PathSeparator

if ($IsWindows) {
	$global:IsRoot = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") 
	$username = $env:USERNAME
} else {
	$username = $env:USER
	$global:IsRoot=(id -u) -eq 0
}

function Invoke-ExaLong {
	eza --long @Args
}

function Invoke-ExaLongAll {
	eza --long --all @Args
}

function Invoke-BatHelp {
	$input | bat --language help
}

function Invoke-GitStatus {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git status @w
}

function Invoke-GitDiff {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git diff @w
}

function Invoke-GitCommit {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git commit -m @w
}

function Invoke-GitCommitAll {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git commit -am @w
}

function Invoke-GitPull {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git pull @w
}

function Invoke-GitPush {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git push @w
}

function Invoke-GitAdd {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	git add @w
}

function Invoke-GitCloneDepth1 {
	param ([string[]]$objects)
	git clone --depth=1 $objects
}

function Invoke-GitLog {
	param ([string[]]$objects)
	git log $objects
}

function Invoke-GitLogShort {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w,
		[int]$n = 10
	)
	git log --oneline "-n ${n}" @w
}

function Invoke-GitStashList {
    git stash list ("--pretty=format:%C(red)%h%C(reset) - %C(dim yellow)(%C(reset)" +
		"%C(brightmagenta)%gd%C(dim yellow))%C(reset) %<(70,trunc)%s %C(green)(%cr) %C(bold blue)" +
		"<%an>%C(reset)")
}

function Invoke-CargoClippy {
	$fmtArgs = $Args | Join-String -Separator " "
	Write-Host "`e]0;cargo clippy --workspace ${fmtArgs}`a" -NoNewline
	cargo clippy --workspace @Args
}

function Invoke-CargoClippyAllTargets {
	$fmtArgs = $Args | Join-String -Separator " "
	Write-Host "`e]0;cargo clippy --workspace --all-targets ${fmtArgs}`a" -NoNewline
	cargo clippy --workspace --all-targets @Args
}

function Invoke-CargoFormat {
	$fmtArgs = $Args | Join-String -Separator " "
	Write-Host "`e]0;cargo fmt ${fmtArgs}`a" -NoNewline
	cargo fmt @Args
}

function Remove-ItemForce {
	Remove-Item -Force -Recurse -Confirm -Path @Args
}

function Invoke-Neovide {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	$arguments = @()
	$neovidePath = $IsWindows ? "neovide.exe" : "neovide"
	if (Test-Path Env:\WSL_DISTRO_NAME) {
		$arguments += "--wsl"
		$neovidePath = "neovide.exe"
	}
	$arguments += "--"
	$arguments += $w
	Start-Process -FilePath $neovidePath -ArgumentList $arguments
}

if ($null -ne (Get-Command -ErrorAction SilentlyContinue kitten)) {
	function HyperlinkedGrep {
		kitten hyperlinked-grep @Args
	}

	#Set-Alias -Scope Global -Force -Name rg -Value HyperlinkedGrep
}

function Invoke-FdHiddenNoIgnore {
	fd --hidden --no-ignore --ignore-case @Args
}

function Invoke-RgHiddenNoIgnore {
	rg --hidden --no-ignore --ignore-case @Args
}

Set-Alias -Name f -Value "eza"
Set-Alias -Name ff -Value Invoke-ExaLong
Set-Alias -Name fa -Value Invoke-ExaLongAll
Set-Alias -Name a -Value "bat"
Set-Alias -Name ah -Value "Invoke-BatHelp"
Set-Alias -Name paiton -Value "python3"
Set-Alias -Name open -Value Start-Process
Set-Alias -Name c -Value Invoke-CargoClippy
Set-Alias -Name ca -Value Invoke-CargoClippyAllTargets
Set-Alias -Name cf -Value Invoke-CargoFormat
Set-Alias -Option AllScope -Force -Name "g" -Value "git"
Set-Alias -Option AllScope -Force -Name "gs" -Value Invoke-GitStatus
Set-Alias -Option AllScope -Force -Name "gd" -Value Invoke-GitDiff
Set-Alias -Option AllScope -Force -Name "gcm" -Value Invoke-GitCommit
Set-Alias -Option AllScope -Force -Name "gca" -Value Invoke-GitCommitAll
Set-Alias -Option AllScope -Force -Name "gpl" -Value Invoke-GitPull
Set-Alias -Option AllScope -Force -Name "gp" -Value Invoke-GitPush
Set-Alias -Option AllScope -Force -Name "ga" -Value Invoke-GitAdd
Set-Alias -Option AllScope -Force -Name "gcd1" -Value Invoke-GitCloneDepth1
Set-Alias -Option AllScope -Force -Name "gl" -Value Invoke-GitLog
Set-Alias -Option AllScope -Force -Name "gls" -Value Invoke-GitLogShort
Set-Alias -Option AllScope -Force -Name "gsl" -Value Invoke-GitStashList
Set-Alias -Option AllScope -Force -Name "rmrf" -Value Remove-ItemForce
Set-Alias -Option AllScope -Force -Name "v" -Value "nvim"
Set-Alias -Option AllScope -Force -Name "vv" -Value Invoke-Neovide
Set-Alias -Option AllScope -Force -Name "fdhnoi" -Value Invoke-FdHiddenNoIgnore
Set-Alias -Option AllScope -Force -Name "fdnohi" -Value Invoke-FdHiddenNoIgnore
Set-Alias -Option AllScope -Force -Name "rghnoi" -Value Invoke-RgHiddenNoIgnore
Set-Alias -Option AllScope -Force -Name "rgnohi" -Value Invoke-RgHiddenNoIgnore
Set-Alias -Force -Name "^" -Value Select-Object

function Get-CommandSource {
	param (
		$CommandName,
		[switch]
		$Last = $false
	)

	$Command = Get-Command -ErrorAction Stop $CommandName 

	while ($Command.CommandType -eq [System.Management.Automation.CommandTypes]::Alias) {
		$Command = Get-Command $Command.Definition
	}

	$Output = [System.Collections.ArrayList]@()
	[void]$Output.Add($Command.Source)

	if ($Command.CommandType -eq [System.Management.Automation.CommandTypes]::Application)
	{
		$Item = Get-Item $Command.Source
		while ($null -ne $Item.LinkType) {
			[void]$Output.Add($Item.LinkTarget)
			$Item = Get-Item -ErrorAction SilentlyContinue $Item.LinkTarget 
		}
	}

	if ($Last) {
		return $Output[-1]
	} else {
		return $Output
	}
}

Set-Alias -Option AllScope -Force -Name "gcmd" -Value Get-CommandSource

if ($IsWindows -and (Get-Command -ErrorAction SilentlyContinue which) -eq $null) {
	Set-Alias -Option AllScope -Name "which" -Value Get-Command
}

# if ($env:TMUX -eq $null) {
# 	tmux a
# 	if (!$?) {
# 		tmux
# 	}
# }

Import-Module posh-git

$fnmPath = Join-Path $HOME .local share fnm -Resolve -ErrorAction SilentlyContinue
if ($null -ne $fnmPath) {
	$env:PATH += $PathSep + $fnmPath
}

if ((Get-Command -ErrorAction SilentlyContinue fnm) -ne $null) {
	fnm env | Out-String | Invoke-Expression
	$HasFnm = $true
}

$BunPath = Join-Path $HOME .bun
if (Test-Path $:BunPath) {
	$env:BUN_INSTALL = $BunPath
	$env:PATH += $PathSep + (Join-Path $BunPath bin -Resolve)
}
Remove-Variable -Name BunPath 

$env:LANGUAGE = "en_US"

function Set-LocationWithBat {
	param (
		[string]$Path
	)

	if ($Path -eq $null -or $Path.Trim().Length -eq 0) {
		return (Get-Location).Path
	}

	Set-Location -ErrorAction Stop -Path $Path

	eza
}

Remove-Item alias:\cd
New-Alias cd Set-LocationWithBat

function Set-LocationParent {
	Set-LocationWithBat -Path ".."
}

New-Alias ".." Set-LocationParent -Force

Set-PSReadLineOption -PredictionSource HistoryAndPlugin | Out-Null
Set-PSReadLineOption -PredictionViewStyle ListView | Out-Null
Set-PSReadLineOption -EditMode Windows | Out-Null
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar

$RealScriptPath = (Get-Item $MyInvocation.MyCommand.Source).LinkTarget
$DotfilesDir = Split-Path -Path $RealScriptPath -Parent
$env:PSModulePath += "$([IO.Path]::PathSeparator)$DotfilesDir"

Register-Expand-Abbreviation

enum ColorPreference {
	light
	dark
}
$global:ThemeColorPreference = [ColorPreference]::dark

if ($IsLinux) {
	$env:PATH += $PathSep + (Join-Path $HOME .cargo bin)

    $ExecutionContext.InvokeCommand.CommandNotFoundAction += {
        param (
            [string]$commandName
        )
		/usr/lib/command-not-found --no-failure-msg $commandName
	}
	
	$global:ThemeColorPreference = 
		(gsettings get org.gnome.desktop.interface color-scheme).Contains("light") `
		? [ColorPreference]::Light : [ColorPreference]::Dark

}

if ($env:BAT_THEME -eq $null) {
	$env:BAT_THEME = "gruvbox-${global:ThemeColorPreference}"
}

if ($IsLinux -or $IsMacOS) {
	$env:MANPAGER="nvim +Man!"

	Set-PSReadLineKeyHandler -Chord "Ctrl+Alt+Enter" -Function InsertLineBelow
}

# Register rustup and cargo completions
if ($null -ne (Get-Command -ErrorAction SilentlyContinue rustup)) {
	rustup completions powershell rustup | Join-String -Separator "`n" | Invoke-Expression
}

# Additonal scripts, not commited
$CustomPSSettingsPath = Join-Path $DotfilesDir "Custom.ps1"
if (Test-Path $CustomPSSettingsPath) {
	. $CustomPSSettingsPath
}
