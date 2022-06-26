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
    
    <#
    It "[NEG] <NodeContent.Name> should have duplicated IPAddress" -ForEach @( @{ NodeContent = $NodeContent } ){
        {$New  = ($NodeContent).Where({$_.Status -match 'new'}).IPAddress}
        {$Done = ($NodeContent).Where({$_.Status -match 'done'}).IPAddress}
        ( $New -eq $Done ) | Should -BeTrue
    }
    #>

    It "[POS] <NodeContent.Name> should not have duplicated IPAddress" -ForEach @( @{ NodeContent = $NodeContent } ){
        {$New  = ($NodeContent).Where({$_.Status -match 'new'}).IPAddress}
        {$Done = ($NodeContent).Where({$_.Status -match 'done'}).IPAddress}
        ( $New -ne $Done ) | Should -BeTrue
    }

}