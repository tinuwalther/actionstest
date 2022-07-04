Describe "Test for duplicated values" -Tag 'Test' {

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
