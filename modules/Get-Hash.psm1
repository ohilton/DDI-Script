# Input file destination (string)
# Output result (int) and hash (string)
# result:
# 0 = success (found file and obtained hash)
# 1 = failed (file not found)

function Get-Hash {
    param (
        [string]$Destination
    )

    # Check if the file exists
    if (Test-Path -Path $Destination -PathType Leaf) {
        $result = 0

        # Compute the file hash
        try {
            $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create("SHA256")
            $fileStream = [System.IO.File]::OpenRead($Destination)
            $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
            $fileStream.Close()

            # Convert hash bytes to a hex string
            $hash = [BitConverter]::ToString($hashBytes) -replace '-', ''
        } catch {
            Write-Error "Error computing file hash: $_"
        }
    }

    # Return the output object
    return $result, $hash
}

Export-ModuleMember function Get-Hash