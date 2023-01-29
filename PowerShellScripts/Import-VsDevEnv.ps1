function Import-VsDevEnv {
	$vsInstance = Get-CimInstance MSFT_VSInstance
	Import-Module (Join-Path $vsInstance.InstallLocation "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
	Enter-VsDevShell $vsInstance.IdentifyingNumber -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
}
