# Import the custom modules
Import-Module -Name "./modules/Get-ServerList.psm1"
Import-Module -Name "./modules/Get-Hash.psm1"

# Get the configuration from the JSON file
# Read the JSON file
$jsonContent = Get-Content -Path './config.json' -Raw
# Convert JSON content to PowerShell object
$config = $jsonContent | ConvertFrom-Json

# Check reachability of artifact
    # This will be future

# Store artifact hash
$ArtifactHash = Get-Hash -Destination $config.ArtifactLocation

# Execute Get-ServerList
$serverList = Get-ServerList -SqlServer $config.SQLServer `
                          -Database $config.Database `
                          -Username $config.Username `
                          -Password $config.Password `
                          -WhereClause $config.WhereClause

# Initiate empty results
$results = {}

# Execute Get-Hash on each server
foreach ($server in $serverList) {
    $filePath = '\\' + $server + '.timeforstorm.com\D$\RT\Partitions\p_8659\s_9447\user\DDI_List.csv'
    ($result, $hash) = Get-Hash -Destination $filePath

    if ($result -eq 1) {
        $results[$server] = "File not found"

        $msg = 'The file "' + $filePath + '" does not exist'
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