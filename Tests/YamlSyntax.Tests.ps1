#Requires –Modules psyml

BeforeDiscovery {
    #region Folders
    $RootFolder = $PSScriptRoot | Split-Path -Parent
    $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
    #endregion

    #region Nodes
    $NodeFiles = Get-ChildItem $NodeFolder
    #endregion
}

Describe "Check Yaml-Files" {

    It "[POS] Reading of <Nodes.Name> should not throw" -ForEach @( @{ Nodes = $NodeFiles } ){
        { $Nodes.Fullname | ConvertFrom-Yaml } | Should -Not -Throw
    }

}

Describe "Check Yaml-Content" {

    BeforeDiscovery {
        #region Folders
        $RootFolder = $PSScriptRoot | Split-Path -Parent
        $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
        #endregion
    
        #region Nodes
        $NodeContent = foreach($node in (Get-ChildItem $NodeFolder)){
            Write-Verbose $node.Name
            Get-Content -Path $node.FullName | ConvertFrom-Yaml
        }        
        #endregion
    }

    It "[POS] Get YAML-Nodes <NodeContent.Name> should BeOfType PSCustomObject" -ForEach @( @{ NodeContent = $NodeContent } ){
        ( $NodeContent ) | Should -BeOfType [PSCustomObject]
    }
    
    It "[POS] Get YAML-Nodes Name should have a value" -TestCases @( @{ NodeContent = $NodeContent } ){
        foreach($item in $NodeContent){
            ($item.Name.length) | Should -BeGreaterThan 0
        } 
    }
    It "[POS] Get YAML-Nodes IPAddress should have a value" -TestCases @( @{ NodeContent = $NodeContent } ){
        foreach($item in $NodeContent){
            ($item.IPAddress.length) | Should -BeGreaterThan 0
        } 
    }
    It "[POS] Get YAML-Nodes Subnet should have a value" -TestCases @( @{ NodeContent = $NodeContent } ){
        foreach($item in $NodeContent){
            ($item.Subnet.length) | Should -BeGreaterThan 0
        } 
    }
    It "[POS] Get YAML-Nodes Gateway should have a value" -TestCases @( @{ NodeContent = $NodeContent } ){
        foreach($item in $NodeContent){
            ($item.Gateway.length) | Should -BeGreaterThan 0
        } 
    }
    It "[POS] Get YAML-Nodes Status should have a value" -TestCases @( @{ NodeContent = $NodeContent } ){
        foreach($item in $NodeContent){
            ($item.Status.length) | Should -BeGreaterThan 0
        } 
    }

    It "[POS] Get YAML-Nodes <NodeContent.Name> should Contain Status 'new'" -ForEach @( @{ NodeContent = $NodeContent } ){
        ( $NodeContent.Status ) | Should -Contain 'new'
    }

}