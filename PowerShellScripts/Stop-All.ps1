function Stop-All {
	param (
		[Parameter(Mandatory = $true)]
		[String]
		$Name,

		[Switch]
		$Force
	)

	$Processes = Get-Process | Where-Object Name -match $Name

	if (-not $Force) {
		Write-Output $Processes
		
		$Continue = $Host.UI.PromptForChoice(
			"Stop-All", 
			"Do you want to kill these processes?", 
			@("&Yes", "&No"),
			1
		)

		if ($Continue -ne 0) {
			return
		}
	}

	$Processes | ForEach-Object { $_.Kill() }
}

