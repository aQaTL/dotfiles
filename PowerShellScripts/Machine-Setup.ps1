function Install-NeovimConfig {
	[CmdletBinding()]
	param (
	)

	$MyNeovimConfigDir = Join-Path (Get-Item $PSScriptRoot).Parent "neovim"
	Write-Verbose "Using neovim config dir: $MyNeovimConfigDir"

	if ($IsWindows) {
		$PackerDir = "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
		$NeovimConfigDir = "$env:LOCALAPPDATA\nvim"
	} else {
		$PackerDir = "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
		$NeovimConfigDir = "$HOME/.config/nvim"
	}
	$NeovimInitFile = Join-Path $NeovimConfigDir "init.lua"

	if (Test-Path $PackerDir) {
		Write-Warning "Packer dir already exists! ($PackerDir)"
	} else {
		Write-Debug "Downloading packer to $PackerDir"
		git clone --depth 1 "https://github.com/wbthomason/packer.nvim" $PackerDir
	}

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
	
	$MyNeovimConfigAfterDir = Join-Path $MyNeovimConfigDir "after"

	if ($IsWindows) {
		$MyNeovimConfigDir = $MyNeovimConfigDir.Replace("\", "\\")
		$MyNeovimConfigAfterDir = $MyNeovimConfigAfterDir.Replace("\", "\\")
	} 
	$Config = @"
vim.opt.runtimepath:append(',$MyNeovimConfigDir')
vim.opt.runtimepath:append(',$MyNeovimConfigAfterDir')
require(`"dotfiles`")
"@
	
	Write-Host "Config file:"
	Write-Host ("=" * 80)
	Write-Host "$Config"
	Write-Host ("=" * 80)
	Write-Verbose "Writing config file to $NeovimInitFile"

	$PackerConfigFile = Join-Path $MyNeovimConfigDir "lua" "dotfiles" "packer.lua"

	Write-Verbose "Now, to download the plugins: "
	Write-Verbose "1. Open $PackerConfigFile in neovim"
	Write-Verbose "2. Run :so"
	Write-Verbose "3. Run :PackerSync"

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
