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


Describe "Check Yaml-files" {

    It "[POS] <Nodes.Name> should not throw" -ForEach @( @{ Nodes = $NodeFiles } ){
        { $Nodes.Fullname | ConvertFrom-Yaml } | Should -Not -Throw
    }

}