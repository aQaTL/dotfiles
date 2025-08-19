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
	$ConfigSetInvocations = [ordered]@{
		InitialKeyRepeatDelay = "gsettings set org.gnome.desktop.peripherals.keyboard delay 280";
		MouseButtonModifier = "gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Alt>'";
		MouseAccelerationDisable = "gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'";
		CenterWindow = "gsettings set org.gnome.desktop.wm.keybindings move-to-center `"['<Super>Return']`"";
	}

	Write-Host "Config to be applied:"
	Write-Host $ConfigSetInvocations
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
	
	foreach ($it in $ConfigSetInvocations.GetEnumerator()) {
		Invoke-Expression -Command $it.Value 
	}
}

function Install-GitDelta {
	param (
		[switch]$Force
	)
	
	$ForceFlag = $Force ? "--force" : $null
	cargo install --locked $ForceFlag git-delta

	git config set --global core.pager delta
	git config set --global interactive.diffFilter "delta --color-only"
	git config set --global delta.navigate true
	git config set --global merge.conflictStyle zdiff3
}

function Setup-GitConfig {
	git config set --global push.autoSetupRemote true
	git config set --global rerere.enabled true
	git config set --global init.defaultBranch "master"
}
