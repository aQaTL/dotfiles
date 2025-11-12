function ConvertFrom-UnixTimeStamp {
	param (
		[Parameter(Mandatory = $true)]
		[double]$UnixTimeStamp,

		[ValidateSet("seconds", "milliseconds")]
		[string]$Resolution = "seconds"
	)

	$timespan = switch ($Resolution) {
		"seconds" { ([System.TimeSpan]::FromSeconds($UnixTimeStamp)) }
		"milliseconds" { ([System.TimeSpan]::FromMilliseconds($UnixTimeStamp)) }
	}
	$d = (Get-Date 01.01.1970) + $timespan
	return $d.ToString("yyyy-MM-dd HH:mm:ss.ffffff")
}

function ConvertTo-UnixTimeStamp {
	param (
		[DateTime]$Date = (Get-Date),

		[ValidateSet("seconds", "milliseconds")]
		[string]$Resolution = "seconds"
	)

	$multiplier = switch ($Resolution) {
		"seconds" { 1 }
		"milliseconds" { 1000 }
	}

    return [UInt64](Get-Date -Date $Date -UFormat %s) * $multiplier
}
