function Restart-AutoHotKey {
	Get-Process `
		| Where-Object Name -match "auto" `
		| Select-Object -First 1 `
		| ForEach-Object {
			$process = Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)"

			$commandline = $process.CommandLine
			$path = $process.Path
			$arguments = $commandline.Substring($path.Length + 3)

			$_.Kill()

			Start-Process -FilePath $path -ArgumentList $arguments

			Write-Output "Done"
		}
}
