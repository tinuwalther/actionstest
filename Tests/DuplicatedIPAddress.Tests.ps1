#Requires –Modules psyml
BeforeDiscovery {
    #region Folders
    $RootFolder = $PSScriptRoot | Split-Path -Parent
    $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
    #endregion

    #region Nodes
    $NodeContent = foreach($node in (Get-ChildItem $NodeFolder)){
        Get-Content -Path $node.FullName | ConvertFrom-Yaml
    }
    #endregion
}

Describe "Check for duplicated IPAddress" {
    
    It "[POS] <NodeContent.Name> should not have duplicated IPAddress" -ForEach @( @{ NodeContent = $NodeContent } ){
        ( ($NodeContent).Where({$_.Status -match 'new'}).IPAddress -eq ($NodeContent).Where({$_.Status -match 'done'}).IPAddress ) | Should -BeFalse
    }

}