Describe "Test for duplicated values" -Tag 'Required' {

    BeforeAll {
        $RootFolder = $PSScriptRoot | Split-Path -Parent
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
            $Nodes = foreach($node in (Get-ChildItem $NodeFolder )){
                Get-Content -Path $node.FullName | ConvertFrom-Yaml
            }
            $ret = foreach($item in ($Nodes.$Filed | Group-Object)){
                if($item.count -gt 1){
                    $item.Name
                }
            }
            return $ret
    
        }
    
    }

    It "[POS] <_> should not have duplicated values" -ForEach 'Name', 'IPAddress' {
        Get-DuplicatedValue -Filed $_ | Should -BeNullOrEmpty
    }
}
