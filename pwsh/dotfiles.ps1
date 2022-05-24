<#
.SYNOPSIS
    Powershell script for managing my dotifles.

#>

param (
    [ValidateSet("full-setup", "link")]
    [Parameter(Mandatory = $true)]
    [string]$Command
)

function Main {
    $Command = $Command.Replace("-", "")

    & $Command
}

function FullSetup {
    Write-Output "Running $($MyInvocation.MyCommand)"

    Link
}

function Link {
    Write-Output "Running $($MyInvocation.MyCommand)"

    LinkPowerShell

    if ($IsMacOS -or $IsLinux) {
        LinkBashRc
    }
}

function LinkPowerShell {
    Write-Output "Running $($MyInvocation.MyCommand)"

    [System.IO.DirectoryInfo]$scriptPath = $MyInvocation.ScriptName
    [System.IO.DirectoryInfo]$repoPath = $scriptPath.Parent.Parent

    if (Test-Path $PROFILE) {
        Write-Output "Profile file already exists, skipping. ($PROFILE)"
        return
    }

    [String]$dotfilesProfile = Join-Path $repoPath "Microsoft.PowerShell_profile.ps1"
    Write-Output "Creating symbolic link from $dotfilesProfile to $PROFILE"
    $null = New-Item -Type SymbolicLink -Path $PROFILE -Target $dotfilesProfile
}

function LinkBashRc {

}

Main