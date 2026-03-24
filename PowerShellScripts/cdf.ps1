function cdf {
	$Arguments = $Args -join " "

	[string]$path = (fd --type dir | fzf -q $Arguments)
	if (-not $?) {
		return
	}

	[System.IO.FileSystemInfo]$path = Get-Item $path
	if ($path.UnixStat.ItemType -ne "Directory") {
		[string]$path = $path | Split-Path -Parent
	}
	Push-Location $path
	eza
}
