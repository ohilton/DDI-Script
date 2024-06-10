Import-Module -Name "./modules/Get-SHA256Hash.psm1"
Import-Module -Name "./modules/Get-NormalLineEndings.psm1"

function Get-ArtifactHash {
    param (
    )

    # Get hash
    $getHashResult = Get-Hash -Destination "artifact\DDI_List.csv"
    $hash = $getHashResult.hash

    # Notify last modified time
    $file = Get-Item "artifact\DDI_List.csv"
    $lastModified = $file.LastWriteTime
    Write-Host 'Last modified time is '$lastModified'. Please refer to wiki to ensure this is up to date.'

    # Write/Output hash
    Write-Host 'Artifact hash: ' $hash
    Write-Output $hash
}

Export-ModuleMember -Function Get-ArtifactHash
