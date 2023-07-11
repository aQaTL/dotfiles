function Send-File {
	param (
		[Parameter(Mandatory = $true)]
		[string]$Path,

		[string]$Address = "localhost",

		[UInt16]$Port = 8080
	)

	[Byte[]]$fileContents = [System.IO.File]::ReadAllBytes((Resolve-Path -Path $Path))
	
	$listener = [System.Net.HttpListener]::new()

	try {
		$listener.Prefixes.Add("http://${Address}:$Port/")
		$listener.Start()

		# Blocks until a client connects
		$context = $listener.GetContext()
		
		Write-Output $context.Request.UserHostAddress

		$context.Response.StatusCode = 200
		$context.Response.OutputStream.Write($fileContents, 0, $fileContents.Count)
	}
	finally {
		$context.Response.Close()
		$listener.Close()
	}
}
