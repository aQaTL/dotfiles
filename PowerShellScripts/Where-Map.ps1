function Where-Map {
	[cmdletbinding()]

	param (
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[Object]$InputObject,

		[Parameter(Mandatory = $true, Position = 0)]
		[scriptblock]$Filter
	)

	process {
		$x = $InputObject | ForEach-Object -Process $Filter
		if ($null -ne $x) {
			return $x
		}
	}

}

function Where-Regex {
	[cmdletbinding()]

	param (
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[Object]$InputObject,

		[Parameter(Mandatory = $true, Position = 0)]
		[regex]$Filter
	)

	process {
		[string]$s = $InputObject.ToString()
		$regex_matches = $Filter.Matches($s)
		if ($regex_matches.Count -ne 0) {
			return $regex_matches
		}
	}
}
