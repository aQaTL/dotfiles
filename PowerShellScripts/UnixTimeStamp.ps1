function ConvertFrom-UnixTimeStamp {
	param (
		[Parameter(Mandatory = $true)]
		[double]$UnixTimeStamp
	)

	$d = (Get-Date 01.01.1970) + ([System.TimeSpan]::FromSeconds($UnixTimeStamp))
	return $d.ToString("yyyy-MM-dd HH:mm:ss.ffffff")
}

function ConvertTo-UnixTimeStamp {
	param (
		[DateTime]$Date = (Get-Date)
	)

    return [UInt64](Get-Date -Date $Date -UFormat %s)
}
