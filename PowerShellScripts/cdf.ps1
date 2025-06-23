function cdf {
	[string]$path = (fd --type dir | fzf)
	if (-not $?) {
		return
	}

	[System.IO.FileSystemInfo]$path = Get-Item $path
	if ($path.UnixStat.ItemType -ne "Directory") {
		[string]$path = $path | Split-Path -Parent
	}
	cd $path
}
