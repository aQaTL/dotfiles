function Import-VsDevEnv {
	$vsInstance = (GetVsInstallationInfoFromCimInstance) ?? (GetVsInstallationInfoFromVsWhere)
	Import-Module (Join-Path $vsInstance.location "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
	Enter-VsDevShell $vsInstance.id -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
}

function GetVsInstallationInfoFromCimInstance {
	$vsInstance = Get-CimInstance MSFT_VSInstance
	if ($null -eq $vsInstance) {
		return $null;
	}
	return [PSCustomObject]@{
		id = $vsInstance.IdentifyingNumber
		location = $vsInstance.InstallLocation;
	}
}

function GetVsInstallationInfoFromVsWhere {
	$vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
	$vsInstance = ((& $vswhere -latest -format json) | ConvertFrom-Json)[0]
	return [PSCustomObject]@{
		id = $vsInstance.instanceId
		location = $vsInstance.installationPath
	}
}

