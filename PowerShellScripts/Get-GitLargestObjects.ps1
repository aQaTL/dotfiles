function Get-GitLargestObjects {
	git rev-list --objects --all `
		| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' `
		| sed -n 's/^blob //p' `
		| sort --numeric-sort --key=2 `
		| tail -n 10 `
		| cut -c 1-12,41- `
		| numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest `
		| ForEach-Object { 
			Write-Host "Object: $_" -ForegroundColor Cyan
			git log --raw --all --find-object=$(git rev-parse --verify $_.split(" ")[0]) 
			Write-Host ("=" * 80)
			Write-Host ""
		}
}
