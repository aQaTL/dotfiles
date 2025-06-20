function cdf {
	[string]$path = fzf
	if (-not $?) {
		return
	}

	[System.IO.FileSystemInfo]$path = Get-Item $path
	if ($path.UnixStat.ItemType -ne "Directory") {
		[string]$path = $path | Split-Path -Parent
	}
	cd $path
}
