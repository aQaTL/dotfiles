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

function Restart-SshAgentBridge {
	if (-not (Test-Path Env:\SSH_AUTH_SOCK)) {
		throw "SSH_AUTH_SOCK environment variable not set"
	}

	if (Test-Path $env:SSH_AUTH_SOCK) {
		Write-Host "Removing socket (${env:SSH_AUTH_SOCK})"
		Remove-Item $env:SSH_AUTH_SOCK
	}

	if ($null -ne (Get-Process | Where-Object Name -eq "socat" -OutVariable socat_process)) {
		Write-Host "Kiling socat"
		$socat_process | Stop-Process
	}

	Write-Host "starting socat"
	setsid socat "UNIX-LISTEN:${env:SSH_AUTH_SOCK},fork" "EXEC:`"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent`",nofork" &
}
