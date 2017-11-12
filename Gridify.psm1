# Dot Sourcing files

Get-ChildItem "$PSScriptRoot\Source\" | ForEach-Object {
   . $_.FullName
}

#$ProcessID = 1..10 | ForEach-Object { (Start-Process cmd -PassThru).ID }
#Set-ApplicationGrid -ProcessID $ProcessID -Custom "**,*****,***"

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
# Export-ModuleMember -Function Set-GridLayout -Alias
