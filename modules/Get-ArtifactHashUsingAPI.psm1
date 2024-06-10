Import-Module -Name "./modules/Get-SHA256Hash.psm1"
Import-Module -Name "./modules/Get-NormalLineEndings.psm1"

function Get-ArtifactHashUsingAPI {
    param (
        [string]$Token
    )

    # Define variables
    $GitLabToken = $Token  # Replace with your GitLab Personal Access Token
    $GitLabApiUrl = "https://gitlab.redwood.com/api/v4"  # Replace with your GitLab instance URL if self-hosted
    $ProjectId = "1905"  # Replace with your GitLab project ID
    $FilePath = "files/DDI_List.csv"  # Replace with the path to the file in the repository
    $Branch = "master"  # Replace with the branch name (e.g., 'main', 'master', etc.)

    # URL encode the file path
    $EncodedFilePath = [System.Web.HttpUtility]::UrlEncode($FilePath)

    # Build the API URL to get the file content
    $ApiUrl = "$GitLabApiUrl/projects/$ProjectId/repository/files/$EncodedFilePath/raw?ref=$Branch"
    Write-Host $ApiUrl
    Write-Host $Token
    try {
        # Fetch the file content from GitLab
        Write-Host "Trying Invoke-RestMethod"
        $response = Invoke-RestMethod -Uri $ApiUrl -Headers @{ "PRIVATE-TOKEN" = $GitLabToken } -Method Get
        Write-Host "File content retrieved from GitLab"

        # Normalize line endings of the fetched content
        $normalizedResponse = Get-NormalLineEndings -Content $response

        # Compute the hash of the fetched and normalized file content
        $hashGitLab = Get-SHA256Hash -InputString $normalizedResponse
        Write-Host "GitLab file hash (SHA256): $hashGitLab"

    } catch {
        Write-Host "Error in Get-ArtifactHash: $_"
        Write-Host "Full Exception: $($_ | Out-String)"
    }

    Write-Output $hashGitLab
}

Export-ModuleMember -Function Get-ArtifactHashUsingAPI
