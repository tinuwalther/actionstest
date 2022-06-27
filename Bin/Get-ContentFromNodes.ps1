#Requires –Modules psyml
[CmdletBinding()]
param ()

#region Folders
$RootFolder = $PSScriptRoot | Split-Path -Parent
$BinFolder  = Join-Path -Path $RootFolder -ChildPath 'Bin'
$NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
$TestFolder = Join-Path -Path $RootFolder -ChildPath 'Tests'
#endregion

Write-Verbose $($RootFolder)
Write-Verbose $($NodeFolder)

#region Nodes
$NodeContent = foreach($node in (Get-ChildItem $NodeFolder)){
    Write-Verbose $node.Name
    Get-Content -Path $node.FullName | ConvertFrom-Yaml
}
$NodeNew  = ($NodeContent).Where({$_.Status -match 'new'})
$NodeDone = ($NodeContent).Where({$_.Status -match 'done'})

Write-Verbose "Name: $($NodeContent.Name | Out-String)"
Write-Verbose "Status: $($NodeContent.Status | Out-String)"
#endregion

Write-Verbose $($NodeNew.Name)
Write-Verbose $($NodeDone.Name)

return $NodeDone, $NodeNew