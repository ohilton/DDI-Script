# Import the required assemblies for SQL Server
Add-Type -AssemblyName System.Data

function Get-ServerList {
    param (
        [string]$SqlServer,
        [string]$Database,
        [string]$Username,
        [string]$Password,
        [string]$WhereClause
    )

    # Construct the SQL query with the provided WHERE clause
    $query = "SELECT * FROM RTSinfonia..Chassis WHERE $WhereClause WITH(NOLOCK)"

    # Create a new SQL connection
    $connectionString = "Server=$SqlServer;Database=$Database;User Id=$Username;Password=$Password;"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    try {
        $connectionString = "Server=$SqlServer;Database=$Database;User Id=$Username;Password=$Password;"
        Write-Host "Connection String: $connectionString"
        # Open the connection
        Write-Host "Attempting to open connection..."
        $connection.Open()

        # Create a new SQL command
        $command = $connection.CreateCommand()
        $command.CommandText = $query

        # Execute the command and read the results
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
        $dataSet = New-Object System.Data.DataSet
        $adapter.Fill($dataSet)

        # Return the results
        return $dataSet.Tables[0]
    } catch {
        Write-Error "Error executing SQL query: $_"
    } finally {
        # Ensure the connection is closed
        $connection.Close()
    }
}

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