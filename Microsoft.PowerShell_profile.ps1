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

	Write-Host "${global:username}" -NoNewLine -ForegroundColor 3
	Write-Host "|" -NoNewLine

	Write-Host "$($currentDir)" -NoNewLine -ForegroundColor 6
	Write-Host "$" -NoNewLine

	" "
}

function RefreshEnv {
	& $PROFILE
}

$global:HOSTNAME="$(hostname)"

$Sep = [IO.Path]::DirectorySeparatorChar
$PathSep = [IO.Path]::PathSeparator

if ($IsWindows) {
	$global:IsRoot = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") 
	$username = $env:USERNAME
} else {
	$username = $env:USER
	$global:IsRoot=(id -u) -eq 0
}

if ($env:BAT_THEME -eq $null) {
	$env:BAT_THEME = "gruvbox-dark"
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

function Invoke-GitLogOneline {
	param ([string[]]$objects)
	git log --oneline $objects
}

function Invoke-CargoClippy {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	cargo clippy --all-targets @w
}

function Invoke-CargoFormat {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	cargo fmt @w
}

function Remove-ItemForce {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
	Remove-Item -Force -Recurse -Confirm @w 
}

function Invoke-Neovide {
	param (
		[Parameter(Position = 0, ValueFromRemainingArguments)]
		[string[]]
		$w
	)
    $neovideArgs = @()
    if (Test-Path Env:\WSL_DISTRO_NAME) {
        $neovideArgs += "--wsl"
    }
	neovide.exe --geometry 87x46 @neovideArgs -- @w
}

function Job {
	param (
		[Parameter(Mandatory = $true)]
		[ScriptBlock]
		$ScriptBlock
	)

	Start-Job -ScriptBlock $ScriptBlock | Receive-Job -Wait -AutoRemoveJob
}

Set-Alias -Name f -Value "exa"
Set-Alias -Name a -Value "bat"
Set-Alias -Name paiton -Value "python3"
Set-Alias -Name clpy -Value Invoke-CargoClippy
Set-Alias -Name cf -Value Invoke-CargoFormat
Set-Alias -Option AllScope -Force -Name "gs" -Value Invoke-GitStatus
Set-Alias -Option AllScope -Force -Name "gd" -Value Invoke-GitDiff
Set-Alias -Option AllScope -Force -Name "gcm" -Value Invoke-GitCommit
Set-Alias -Option AllScope -Force -Name "gca" -Value Invoke-GitCommitAll
Set-Alias -Option AllScope -Force -Name "gpl" -Value Invoke-GitPull
Set-Alias -Option AllScope -Force -Name "gp" -Value Invoke-GitPush
Set-Alias -Option AllScope -Force -Name "ga" -Value Invoke-GitAdd
Set-Alias -Option AllScope -Force -Name "gcd1" -Value Invoke-GitCloneDepth1
Set-Alias -Option AllScope -Force -Name "gl" -Value Invoke-GitLogOneline
Set-Alias -Option AllScope -Force -Name "rmrf" -Value Remove-ItemForce
Set-Alias -Option AllScope -Force -Name "vv" -Value Invoke-Neovide

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

# if ($env:TMUX -eq $null) {
# 	tmux a
# 	if (!$?) {
# 		tmux
# 	}
# }

Import-Module posh-git

$env:PATH += "${PathSep}$HOME${Sep}.fnm"

if ((Get-Command -ErrorAction SilentlyContinue fnm) -ne $null) {
	fnm env --use-on-cd | Out-String | Invoke-Expression
	$HasFnm = $true
}

$env:LANGUAGE = "en_US"

function Set-LocationWithBat {
	param (
		$Path
	)

	if ($Path -eq $null -or $Path.Trim().Length -eq 0) {
		return (Get-Location).Path
	}

	Set-Location -ErrorAction Stop -Path $Path

	# I'm not sure if this actually is needed 
	#if ($HasFnm) {
		#Set-FnmOnLoad
	#}

	exa
}

Remove-Item alias:\cd
New-Alias cd Set-LocationWithBat

Set-PSReadLineOption -PredictionSource HistoryAndPlugin | Out-Null
Set-PSReadLineOption -PredictionViewStyle ListView | Out-Null
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

$RealScriptPath = (Get-Item $MyInvocation.MyCommand.Source).LinkTarget
$DotfilesDir = Split-Path -Path $RealScriptPath -Parent
$env:PSModulePath += "$([IO.Path]::PathSeparator)$DotfilesDir"

if ($IsLinux) {
	$env:PATH += "${PathSep}$HOME${Sep}.cargo${Sep}bin"
}
