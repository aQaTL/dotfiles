function Get-DateFromUnix {
	param (
		[Parameter(Mandatory = $true)]
		$Seconds
	)

	return (Get-Date -Date "1970-01-01 00:00:00Z").ToUniversalTime().AddSeconds($Seconds)
}
