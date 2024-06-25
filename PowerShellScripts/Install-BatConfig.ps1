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
