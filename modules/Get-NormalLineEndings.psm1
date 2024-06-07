function Get-NormalLineEndings {
    param (
        [string]$Content
    )

    return $Content -replace "`r`n", "`n" -replace "`r", "`n"
}

Export-ModuleMember -Function Get-NormalLineEndings
