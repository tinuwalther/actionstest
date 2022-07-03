BeforeDiscovery {
    $yamlpath   = 'F:\github.com\actionstest\Nodes\example.yml'
    $yamlfile   = Get-Item $yamlpath
    $yamlobject = get-content $yamlfile | ConvertFrom-Yaml
}

Describe "Validate Input" -Tag 'Required' {
    
    Context "Validate Input of field Name: <Filed>" -ForEach @{ Filed = $($yamlobject.Name) } {
        It "[POS] The Name should contains characters and numbers" {
            $Filed | Should -Match "\w+\d+"
        }
    }
    Context "Validate Input of field IPAddress: <Filed>" -ForEach @{ Filed = $($yamlobject.IPAddress) } {
        It "[POS] The IPAddress should contains IPv4Address" {
            $Filed | Should -Match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
        }
    }

    Context "Validate Input of field Subnet: <Filed>" -ForEach @{ Filed = $($yamlobject.Subnet) } {
        It "[POS] The Subnet should contains Subnet mask" {
            $Filed | Should -Match '^(((255\.){3}(255|254|252|248|240|224|192|128+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$'
        }
    }

    Context "Validate Input of field Gateway: <Filed>" -ForEach @{ Filed = $($yamlobject.Gateway) } {
        It "[POS] The Gateway should contains IPv4Address" {
            $Filed | Should -Match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
        }
    }

    Context "Validate Input of field Status: <Filed>" -ForEach @{ Filed = $($yamlobject.Status) } {
        It "[POS] The Status should contains done or new" {
            $Filed | Should -Match 'done|new'
        }
    }
}

