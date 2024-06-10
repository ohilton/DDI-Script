# Input file destination (string)
# Output result (int) and hash (string)
# result:
# 0 = success (found file and obtained hash)
# 1 = failed (file not found)

Import-Module -Name "./modules/Get-SHA256Hash.psm1"
Import-Module -Name "./modules/Get-NormalLineEndings.psm1"

function Get-Hash {
    param (
        [string]$Destination
    )

    # Initialize result and hash variables
    $result = 1
    $hash = ''

    # Check if the file exists
    if (Test-Path -Path $Destination -PathType Leaf) {
        $result = 0

        # Compute the file hash
        try {
            Write-Host 'Destination: ' $Destination

            $localContent = Get-Content -Path $Destination -Raw
            $normalizedLocalContent = Get-NormalLineEndings -Content $localContent
            $hash = Get-SHA256Hash -InputString $normalizedLocalContent

            # $fileBytes = [System.IO.File]::ReadAllBytes($Destination)
            # $hash = Get-SHA256Hash -ByteArray $fileBytes
            # $fileStream.Close()

            # [System.IO.File]::ReadAllBytes

            # # Convert hash bytes to a hex string
            # $hash = [BitConverter]::ToString($hashBytes) -replace '-', ''
        } catch {
            Write-Error "Error computing file hash: $_"
        }
    }

    # Create a custom object to hold the result and hash
    $output = [PSCustomObject]@{
        Result = $result
        Hash   = $hash
    }

    # Output the object
    Write-Output $output
}

Export-ModuleMember -Function Get-Hash