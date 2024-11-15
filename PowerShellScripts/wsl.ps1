function Open-InWindows {
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
		[String]
		$Path
	)
	
	$windowsPath = wslpath -wa $Path
	wslview $windowsPath
}

Set-Alias -Name openwin -Value Open-InWindows
