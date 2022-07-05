BeforeDiscovery {
    $RootFolder = $PSScriptRoot | Split-Path -Parent
    $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
    $yamlpath   = Join-Path -Path $NodeFolder -ChildPath '*.yml'
    $yamlfile   = Get-ChildItem $yamlpath
}

Describe "Validate Input from <_.Name>" -Tag 'Test' -ForEach $yamlfile {

    BeforeAll{
        $yamlobject = get-content $_.FullName | ConvertFrom-Yaml
    }

    It "[POS] The Property Name should contains characters and numbers" {
        $($yamlobject.Name) | Should -Match "\w+\d+"
    }
    It "[POS] The Property IPAddress should contains IPv4Address" {
        $($yamlobject.IPAddress) | Should -Match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    }
    It "[POS] The Property Subnet should contains Subnet mask" {
        $($yamlobject.Subnet) | Should -Match '^(((255\.){3}(255|254|252|248|240|224|192|128+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$'
    }
    It "[POS] The Property Gateway should contains IPv4Address" {
        $($yamlobject.Gateway) | Should -Match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    }
    It "[POS] The Property Status should contains done or new" {
        $($yamlobject.Status) | Should -Match 'done|new'
    }

}
