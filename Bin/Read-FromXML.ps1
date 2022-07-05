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
    $ret = $null
}

process {
    Write-Verbose "[Process] $function"
    if(Test-Path -Path $InputFile){
        [xml]$doc = Get-Content -path $InputFile
        if ($doc.'test-results'.noNamespaceSchemaLocation -match "nunit") {    
            #region Collect Overview
            $Overview = $doc.'test-results' | ForEach-Object {
                [PSCustomObject]@{
                    TestComputer      = $_.environment.'machine-name'
                    TotalCount        = ([int]$_.total) + [int]($_.'not-run')
                    PassedCount       = ([int]$_.total) - ([int]($_.failures) + [int]($_.skipped) + ([int]$_.errors) + ([int]$_.inconclusive) + ([int]$_.ignored) + ([int]$_.invalid))
                    ErrorCount        = [int]$_.errors
                    FailedCount       = [int]$_.failures
                    SkippedCount      = [int]$_.skipped
                    NotRunCount       = [int]$_.'not-run'
                    InconclusiveCount = [int]$_.inconclusive
                    IgnoredCount      = [int]$_.ignored
                    InvalidCount      = [int]$_.invalid
                    ExecutedAt        = Get-Date "$($_.date) $($_.time)" -f 'yyyy-MM-dd HH:mm:ss'
                }
            }
            $doc.'test-results'.'test-suite' | ForEach-Object {
                $Overview | Add-Member -MemberType NoteProperty -Name Result -Value $_.result
                $Overview | Add-Member -MemberType NoteProperty -Name Duration -Value $_.time
            }
            $Overview | Add-Member -MemberType NoteProperty -Name TestFile -Value $doc.'test-results'.'test-suite'.results.'test-suite'.name
            #endregion

            #region Test Results
            $SuccessTests = $doc.'test-results'.'test-suite'.results.'test-suite'.results.'test-suite'.results.'test-case' | ForEach-Object {
                if(-not([String]::IsNullOrEmpty($_.result))){
                    if($_.result -match "Failure"){
                        Write-Verbose "Failure"
                        $null = $_.failure.message -match '(?<=^)(.*)(?=\.)'
                        $Message = $matches[0]
                    }elseif($_.result -match "Success"){
                        Write-Verbose "Success"
                        $Message = "Success"
                    }else{
                        Write-Verbose "Null" 
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
            }

            $FailedTests = $doc.'test-results'.'test-suite'.results.'test-suite'.results.'test-suite'.results.'test-suite'.results.'test-case' | ForEach-Object {
                if(-not([String]::IsNullOrEmpty($_.result))){
                    if($_.result -match "Failure"){
                        Write-Verbose "Failure"
                        $null = $_.failure.message -match '(?<=^)(.*)(?=\.)'
                        $Message = $matches[0]
                    }elseif($_.result -match "Success"){
                        Write-Verbose "Success"
                        $Message = "Success"
                    }else{
                        Write-Verbose "Null" 
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
            }

            $Tests = $SuccessTests + $FailedTests
            #endregion

            #region Collect Pester Results
            $ret = [PSCustomObject]@{
                PesterFile        = $Overview.TestFile
                ExecutedAt        = $Overview.ExecutedAt
                TestComputer      = $Overview.TestComputer
                TotalCount        = $Overview.TotalCount
                PassedCount       = $Overview.PassedCount
                FailedCount       = $Overview.FailedCount
                ErrorCount        = $Overview.ErrorCount
                SkippedCount      = $Overview.SkippedCount
                NotRunCount       = $Overview.NotRunCount
                InconclusiveCount = $Overview.InconclusiveCount
                IgnoredCount      = $Overview.IgnoredCount
                InvalidCount      = $Overview.InvalidCount
                Duration          = $Overview.Duration
                Result            = $Overview.Result
                Passed            = $SuccessTests | Select-Object TestName, Description, Status, Message, Duration
                Failed            = $FailedTests  | Select-Object TestName, Description, Status, Message, Duration
                Tests             = $Tests
            }
            #endregion
        }else{
            Write-Warning "It's not an NUnitXml-file!"
        }
    }else{
        Write-Verbose "File $($InputFile) not exists."
    }
}

end {
    Write-Verbose "[End]     $function"
    return $ret
}
