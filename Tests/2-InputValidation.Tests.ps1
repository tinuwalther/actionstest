BeforeDiscovery {
    $RootFolder = $PSScriptRoot | Split-Path -Parent
    $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
    $yamlpath   = Join-Path -Path $NodeFolder -ChildPath '*.yml'
    $yamlfile   = Get-ChildItem $yamlpath
}

Describe "Validate Input from <_.Name>" -Tag 'Required' -ForEach $yamlfile {

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

Describe "Test for duplicated values" -Tag 'Required' {

    BeforeAll {
        $RootFolder = $PSScriptRoot | Split-Path -Parent
        $BinFolder  = Join-Path -Path $RootFolder -ChildPath 'Bin'
        $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'

        function Get-DuplicatedValue {
            [CmdletBinding()]
            param(
                [Parameter(
                    Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position = 0
                )]
                [String]$Filed
            )
    
            # Duplicated fields
            #Import-Module "$($env:ProgramFiles)\PowerShell\Modules\psyml"
            $AllNodes = foreach($node in (Get-ChildItem $NodeFolder )){
                $Content = Get-Content -Path $node.FullName | ConvertFrom-Yaml
                $Content | Add-Member -Type NoteProperty -Name File -Value $node.Name
                $Content
            }
    
            $Unique = $AllNodes | Select $Filed -unique
    
            $Properties = @{
                ReferenceObject  = $AllNodes.$Filed
                DifferenceObject = $Unique.$Filed
            }
            $Duplicated = Compare-Object @Properties -PassThru | Select -unique
    
            return $Duplicated
    
        }
    
    }

    It "[POS] <_> should not have duplicated values" -ForEach 'Name', 'IPAddress' {
        Get-DuplicatedValue -Filed $_ | Should -BeNullOrEmpty
    }
}
