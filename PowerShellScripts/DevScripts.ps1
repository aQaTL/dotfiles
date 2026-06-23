function pr_review_start_reset_to_merge_base {
	Set-StrictMode -Version 3.0
	$ErrorActionPreference = "Stop"
	$PSNativeCommandUseErrorActionPreference = $true

	$merge_base_commit_hash = ex "git merge-base HEAD master"
	[void](ex "git reset --soft $merge_base_commit_hash")

	return $null
}

function pr_review_end_reset_back_to_origin {
	Set-StrictMode -Version 3.0
	$ErrorActionPreference = "Stop"
	$PSNativeCommandUseErrorActionPreference = $true

	$current_branch = ex "git branch --show-current"
	[void](ex "git reset --hard origin/$current_branch")

	return $null
}

function print_cmd_and_execute {
	[string]$cmd = $Args -join " "
	Write-Host $cmd -ForegroundColor Magenta
	[string[]]$cmd_output = Invoke-Expression $cmd | Out-String -Stream
	if (${cmd_output}?.Count -ne 0 -and -not [string]::IsNullOrWhiteSpace(${cmd_output}?[0])) {
		Write-Host $cmd_output
	}
	return $cmd_output
}

Set-Alias -Name ex -Scope Script -Value print_cmd_and_execute

function print_script_block_and_execute {
	param(
		[Parameter(Mandatory = $true)]
		[scriptblock]$script
	)

	Write-Host "${script}".Trim() -ForegroundColor Magenta
	$cmd_output = & $script
	if ($null -ne $cmd_output) {
		Write-Host $cmd_output
	}
	return $cmd_output
}

Set-Alias -Name sb_ex -Scope Script -Value print_script_block_and_execute
