function Get-SHA256Hash {
    param (
        [string]$InputString
    )

    # Convert the input string to a byte array
    $byteArray = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $hashBytes = $sha256.ComputeHash($byteArray)
    return -join ($hashBytes | ForEach-Object { $_.ToString("x2") })
}

Export-ModuleMember -Function Get-SHA256Hash
