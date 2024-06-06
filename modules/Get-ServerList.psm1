# Input where clause (string)
# Output server list (array of strings)

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
    $query = "SELECT Name FROM RTSinfonia..Chassis WITH(NOLOCK) WHERE $WhereClause"

    # Create a new SQL connection
    $connectionString = "Server=$SqlServer;Database=$Database;User Id=$Username;Password=$Password;"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    try {
        # Open the connection
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

Export-ModuleMember -Function Get-ServerList
