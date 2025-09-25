function Setup-Machine {
	param (
		[Parameter(Mandatory = $true)]
		[ValidateSet(
			"Install-NeovimConfig", 
			"Install-GhosttyConfig", 
			"Install-GlobalGitIgnore", 
			"Install-KittyConfig", 
			"Install-BatConfig", 
			"Setup-GSettings",
			"Install-GitDelta",
			"Setup-GitConfig"
		)]
		[String[]]$Command
	)

	foreach ($c in $Command) {
		& $Command
	}
}

function Get-DotfilesDir {
	[OutputType([string])]
	param()

	return $PSScriptRoot | Split-Path -Parent
}

function Install-NeovimConfig {
	[CmdletBinding()]
	param (
	)

	$MyNeovimConfigDir = Join-Path (Get-Item $PSScriptRoot).Parent "neovim"
	Write-Verbose "Using neovim config dir: $MyNeovimConfigDir"

	if ($IsWindows) {
		$NeovimConfigDir = "$env:LOCALAPPDATA\nvim"
	} else {
		$NeovimConfigDir = "$HOME/.config/nvim"
	}
	$NeovimInitFile = Join-Path $NeovimConfigDir "init.lua"

	if (Test-Path $NeovimInitFile) {
		Write-Warning "Init file already exists!"
		$Continue = $Host.Ui.PromptForChoice(
			"Install-NeovimConfig",
			"Do you want to overwrite ${NeovimInitFile}?",
			@("&Yes", "&No"),
			1
		)

		if ($Continue -ne 0) {
			return
		}
	}

	New-Item -ItemType Directory -Path $NeovimConfigDir -Force | Out-Null
	
	if ($IsWindows) {
		$MyNeovimConfigDir = $MyNeovimConfigDir.Replace("\", "\\")
	} 
	$Config = @"
vim.opt.runtimepath:append(',$MyNeovimConfigDir')
require(`"dotfiles`")
"@
	
	Write-Host "Config file:"
	Write-Host ("=" * 80)
	Write-Host "$Config"
	Write-Host ("=" * 80)
	Write-Verbose "Writing config file to $NeovimInitFile"

	$Config | Out-File -FilePath $NeovimInitFile -Encoding utf8
	
}

function Install-BatConfig {
	if (-not (Get-Command -ErrorAction SilentlyContinue -Name bat)) {
		throw "bat not installed"
	}

	$BatConfigFilePath = bat --config-file
	if (Test-Path $BatConfigFilePath) {
		Write-Host "Test file already present:"
		bat $BatConfigFilePath
	}

	Write-Host "Bat config path:" $BatConfigFilePath
	bat --generate-config-file
	if (-not $?) {
		throw "Process exited with $LASTEXITCODE"
	}
	if (-not (Test-Path $BatConfigFilePath)) {
		throw "Config file still not present"
	}

	$BatConfig = @"
--style="rule,snip"
"@

	Write-Host "Appending"
	Write-Host $BatConfig

	$BatConfig | Out-File -Encoding utf8 -FilePath $BatConfigFilePath -Append
}

function Install-GlobalGitIgnore {
	$DotfilesDir = Get-Dotfilesdir
	mkdir ${HOME}/.config/git/
	ln -s ${DotfilesDir}/git/.gitignore_global ${HOME}/.config/git/ignore
}

function Install-GhosttyConfig {
	$DotfilesDir = Get-DotfilesDir
	mkdir ${HOME}/.config/ghostty/
	ln -s ${DotfilesDir}/ghostty/config ${HOME}/.config/ghostty/config
}

function Install-KittyConfig {
	$DotfilesDir = Get-DotfilesDir
	$KittyConfigDir = "${HOME}/.config/kitty"
	New-Item -Type Directory -ErrorAction SilentlyContinue $KittyConfigDir
	$KittyConfigFile = Join-Path $KittyConfigDir "kitty.conf"
	$KittyMyConfigFile = Join-Path $DotfilesDir "kitty" "kitty.conf"
	$KittyConfigSrc = "include ${KittyMyConfigFile}"
	if (-not (Test-Path $KittyConfigFile)) {
		$KittyConfigSrc | Out-File $KittyConfigFile
	} else {
		[string[]]$KittyWholeConfigFileSrc = Get-Content $KittyConfigFile
		if (($KittyWholeConfigFileSrc | Where-Object { $_.Contains($KittyConfigSrc) }).Count -ne 0) {
			throw "$KittyConfigFile already includes my config" 
		}
		# Prepend the config 
		[string[]]$KittyWholeConfigFileSrc = @(
			$KittyWholeConfigFileSrc[0], 
			"",
			$KittyConfigSrc
		) + 
			$KittyWholeConfigFileSrc[1..($KittyWholeConfigFileSrc.Count)]

		$KittyWholeConfigFileSrc | Out-File $KittyConfigFile
	}
}


function Setup-GSettings {
	class Setting {
		[string]$Path
		[string]$Key
		[string]$Value

		[string]ToString() {
			return "$($this.Path) $($this.Key) $($this.Value)"
		}
	}

	[Setting[]]$ConfigSetInvocations = @(
		[Setting]@{
			Path = "org.gnome.desktop.peripherals.keyboard";
			Key = "delay";
			Value = 200;
		},
		[Setting]@{
			Path = "org.gnome.desktop.wm.preferences";
			Key = "mouse-button-modifier";
			Value = "'<Alt>'";
		},
		[Setting]@{
			Path = "org.gnome.desktop.peripherals.mouse";
			Key = "accel-profile";
			Value = "'flat'";
		},
		[Setting]@{
			Path = "org.gnome.desktop.wm.keybindings";
			Key = "move-to-center";
			Value = "`"['<Super>Return']`"";
		}
	)
	
	1..12 | ForEach-Object {
		$ConfigSetInvocations += [Setting]@{
			Path = "org.gnome.desktop.wm.keybindings";
			Key = "switch-to-workspace-$_";
			Value = "`"['<Super>F${_}']`"";
		}
	}
	1..12 | ForEach-Object { 
		$ConfigSetInvocations += [Setting]@{
			Path = "org.gnome.desktop.wm.keybindings";
			Key = "move-to-workspace-$_";
			Value = "`"['<Primary><Super>F${_}']`"";
		}
	}

	Write-Host "Config to be applied:"
	Write-Host $($ConfigSetInvocations | ForEach-Object { $_.ToString() } | Join-String -Separator "`n") -ForegroundColor Yellow
	Write-Host ""

	$Continue = $Host.Ui.PromptForChoice(
		"Setup-GSettings",
		"Continue?",
		@("&Yes", "&No"),
		1
	)
	if ($Continue -ne 0) {
		Write-Host "Aborted"
		return
	}
	
	foreach ($it in $ConfigSetInvocations) {
		Write-Host "gsettings " -NoNewline
		Write-Host "set " -ForegroundColor Cyan -NoNewline
		Write-Host $it.Path -ForegroundColor Yellow -NoNewline
		Write-Host " " -NoNewline
		Write-Host $it.Key -ForegroundColor Blue -NoNewline
		Write-Host " " -NoNewline
		Write-Host $it.Value -ForegroundColor Magenta

		$cmd = "gsettings set $($it.Path) $($it.Key) $($it.Value)"

		Invoke-Expression -Command $cmd
	}
}

function Install-GitDelta {
	param (
		[switch]$Force
	)
	
	$ForceFlag = $Force ? "--force" : $null
	cargo install --locked $ForceFlag git-delta

	$git_delta_settings = [ordered]@{
		"core.pager" = "delta";
		"interactive.diffFilter" = "delta --color-only";
		"delta.navigate" = "true";
		"delta.hyperlinks" = "true";
		"merge.conflictStyle" = "zdiff3";
	}
	Setup-GitConfig -Settings $git_delta_settings
}

$setup_gitconfig_settings = [ordered]@{
	"push.autoSetupRemote" = "true";
	"rerere.enabled" = "true";
	"init.defaultBranch" = "master";
}

function Setup-GitConfig {
	[CmdletBinding()]
	param (
		[System.Collections.IEnumerable]$Settings = $setup_gitconfig_settings
	)

	Set-StrictMode -Version Latest
	$ErrorActionPreference = "Stop"
	$PSNativeCommandUseErrorActionPreference = $true

	foreach ($it in $Settings.GetEnumerator()) {
		Write-Host "git config set --global " -NoNewline
		Write-Host "$($it.Key) " -ForegroundColor Yellow -NoNewline
		Write-Host $it.Value -ForegroundColor Magenta
		git config set --global $it.key $it.value
	}
}
