<#
    Read from JUnitXml or NUnitXml
    https://jdhitsolutions.com/blog/powershell/7409/importing-pester-results-into-powershell/
    https://gist.github.com/jdhitsolutions/e350a5e4a338a241e6a2ae31d683f6cc

    $InputFile = 'D:\github.com\PSHPReporting\data\Test-PsNetTools_NUnit.NUnitXml'
    $PesterNUnitXml = ConvertFrom-PesterNUnitXml -InputFile $InputFile
    $PesterNUnitXml
#>
[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 0
    )]
    [String]$InputFile
)

begin{
    $function = $($MyInvocation.MyCommand.Name)
    Write-Verbose "[Begin]   $function"
}

process {
    Write-Verbose "[Process] $function"

    if(Test-Path -Path $InputFile){
        [xml]$doc = Get-Content -path $InputFile
        if ($doc.'test-results'.noNamespaceSchemaLocation -match "nunit") {    

            $doc.'test-results' | ForEach-Object {
                $TestComputer      = $_.environment.'machine-name'
                $TotalCount        = ([int]$_.total) + [int]($_.'not-run')
                $PassedCount       = ([int]$_.total) - ([int]($_.failures) + [int]($_.skipped) + ([int]$_.errors) + ([int]$_.inconclusive) + ([int]$_.ignored) + ([int]$_.invalid))
                $ErrorCount        = [int]$_.errors
                $FailedCount       = [int]$_.failures
                $SkippedCount      = [int]$_.skipped
                $NotRunCount       = [int]$_.'not-run'
                $InconclusiveCount = [int]$_.inconclusive
                $IgnoredCount      = [int]$_.ignored
                $InvalidCount      = [int]$_.invalid
                $ExecutedAt        = Get-Date "$($_.date) $($_.time)" -f 'yyyy-MM-dd HH:mm:ss'
            }

            $doc.'test-results'.'test-suite' | ForEach-Object {
                $Result     = $_.result
                $Duration   = $_.time
            }

            $doc.'test-results'.'test-suite'.results.'test-suite' | ForEach-Object {
                $PesterFile     = $_.name
            }

            $Tests = $doc.'test-results'.'test-suite'.results.'test-suite'.results.'test-suite'.results.'test-case' | ForEach-Object {
                if($_.result -match "Failure"){
                    $null = $_.failure.message -match '(?<=^)(.*)(?=\.)'
                    $Message = $matches[0]
                }elseif($_.result -match "Success"){
                    $Message = "Success"
                }else{
                    $Message = $null
                }
                $TestName = $_.name -split '\.'
                [PSCustomObject]@{
                    TestName    = $TestName[0]
                    Description = $_.description
                    Status      = $_.result
                    Duration    = $_.time
                    Message     = $Message
                }
            }

            $PesterResult = [PSCustomObject]@{
                PesterFile   = $PesterFile
                ExecutedAt   = $ExecutedAt
                TestComputer = $TestComputer

                TotalCount        = $TotalCount
                PassedCount       = ($Tests).Where({ $_.status -match "Success" }).Count
                FailedCount       = $FailedCount
                ErrorCount        = $ErrorCount
                SkippedCount      = $SkippedCount
                NotRunCount       = $NotRunCount
                InconclusiveCount = $InconclusiveCount
                IgnoredCount      = $IgnoredCount
                InvalidCount      = $InvalidCount

                Duration     = $Duration
                Result       = $Result

                Passed       = ($Tests).Where({ $_.status -match "Success" })  | Select-Object TestName, Description, Status, Message, Duration
                Failed       = ($Tests).Where({ $_.status -match "Failure" })  | Select-Object TestName, Description, Status, Message, Duration
                Skipped      = ($Tests).Where({ $_.status -match "Skipped" }) | Select-Object TestName, Description, Status, Message, Duration
                NotRun       = ($Tests).Where({ $_.status -match "NotRun" })  | Select-Object TestName, Description, Status, Message, Duration

                Tests        = $Tests
            } 
        }
    }
}

end {
    Write-Verbose "[End]     $function"
    return $PesterResult
}
