using namespace Microsoft.PowerShell

$global:abbreviations = @{
    "gcm" = "git commit -m `"\c`""
    "gca" = "git commit -am `"\c`""
    "gs" = "git status "
	"gd" = "git diff "
	"gpl" = "git pull "
	"gp" = "git push "
	"ga" = "git add "
	"gcd1" = "git clone --depth=1 "
	"gl" = "git log"
	"rmrf" = "Remove-Item -Force -Recurse -Confirm "
	"fdhnoi" = "fd --hidden --no-ignore --ignore-case "
	"fdnohi" = "fd --hidden --no-ignore --ignore-case "
	"rghnoi" = "rg --hidden --no-ignore --ignore-case "
	"rgnohi" = "rg --hidden --no-ignore --ignore-case "
}

function Register-Expand-Abbreviation {
	Set-PSReadLineKeyHandler `
		-Chord "Alt+e" `
		-ScriptBlock { 
			param([ConsoleKeyInfo]$keyInfo)
			Expand-Abbreviation $keyInfo 
		}
}

function Expand-Abbreviation {
    param([ConsoleKeyInfo]$keyInfo)

    [string]$bufferState = ""
    [Int32]$cursorPos = 0
    [PSConsoleReadLine]::GetBufferState([ref] $bufferState, [ref] $cursorPos)
    [string]$bufferState = $bufferState.Trim()

	$expansion = $global:abbreviations[$bufferState]
	if ($null -eq $expansion) {
		return
	}

	[PSConsoleReadLine]::BackwardDeleteLine($keyInfo)
	
	[Int32]$desiredCursorPos = $expansion.IndexOf("\c")
	if ($desiredCursorPos -eq -1) {
		$desiredCursorPos = $expansion.Length
	}

	[PSConsoleReadLine]::Insert($expansion.Substring(0, $desiredCursorPos))
	[PSConsoleReadLine]::Insert($expansion.Substring(
		[Math]::Min($desiredCursorPos + 2, $expansion.Length))
	)
	[PSConsoleReadLine]::SetCursorPosition($desiredCursorPos)
}

