# Import the custom modules
Import-Module -Name "./modules/Get-ServerList.psm1"
Import-Module -Name "./modules/Get-Hash.psm1"
Import-Module -Name "./modules/Get-ArtifactHash.psm1"

# Get the configuration from the JSON file
# Read the JSON file
$jsonContent = Get-Content -Path './config.json' -Raw
# Convert JSON content to PowerShell object
$config = $jsonContent | ConvertFrom-Json

# Store artifact hash
$ArtifactHash = Get-ArtifactHash -Token $config.token

# Execute Get-ServerList
$serverList = Get-ServerList -SqlServer $config.SQLServer `
                          -Database $config.Database `
                          -Username $config.Username `
                          -Password $config.Password `
                          -WhereClause $config.WhereClause

$serverLength = $serverList.Length - 1

Write-Host $serverLength ' servers found'

# Initiate empty results
$results = @{}

# Execute Get-Hash on each server
for ($i = 1; $i -lt $serverList.Length; $i++) {
    $server = $serverList[$i][0]
    Write-Host 'Processing ' $server

    $filePath = '\\' + $server + '.timeforstorm.com\D$\RT\Partitions\p_8659\s_9447\user\DDI_List.csv'
    $output = Get-Hash -Destination $filePath
    
    $result = $output.Result
    $hash = $output.Hash

    if ($hash) { Write-Host $hash }

    if ($result -ne 0) {
        $results[$server] = "File not found"

        $msg = 'The file "' + $filePath + '" cannot be found'
        Write-Warning $msg
    }

    else {
        if ($hash -eq $ArtifactHash) {
            $results[$server] = "Found and matches artifact"
        }

        else {
            $results[$server] = "Found but does not match"
        }
    }
}

# Process results
Write-Host 'Results:'

foreach ($result in $results.GetEnumerator()) {
    $server = $result.Key
    $msg = $result.Value

    Write-Host $server ': ' $msg
}