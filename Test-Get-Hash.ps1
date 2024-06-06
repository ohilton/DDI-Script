Import-Module -Name "./modules/Get-Hash.psm1"
$filePath = "C:\Users\OWH01\Documents\Projects\DDI-Script\configA.json"

# Call the Get-Hash function and store the result
$output = Get-Hash -Destination $filePath

# Write the result and hash to the console
Write-Host "Result: $($output.Result)"
Write-Host "Hash: $($output.Hash)"