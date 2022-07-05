#Requires –Modules psyml

BeforeDiscovery {
    $RootFolder = $PSScriptRoot | Split-Path -Parent
    $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
    $NodeFiles  = Get-ChildItem $NodeFolder
}

Describe "Validate Yaml Syntax from <_.Name>" -Tag 'Test' -ForEach $NodeFiles {

    It "[POS] Reading of <_.Name> should not throw" {
        { $_.Fullname | ConvertFrom-Yaml } | Should -Not -Throw
    }

}
