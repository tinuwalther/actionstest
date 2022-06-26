#Requires –Modules psyml

#region Folders
$RootFolder = $PSScriptRoot | Split-Path -Parent
$BinFolder  = Join-Path -Path $RootFolder -ChildPath 'Bin'
$NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
$TestFolder = Join-Path -Path $RootFolder -ChildPath 'Tests'
#endregion

#region Nodes
$NodeContent = foreach($node in (Get-ChildItem $NodeFolder)){
    Get-Content -Path $node.FullName | ConvertFrom-Yaml
}
$NodeNew  = ($NodeContent).Where({$_.Status -match 'new'})
$NodeDone = ($NodeContent).Where({$_.Status -match 'done'})
#endregion

return $NodeDone, $NodeNew