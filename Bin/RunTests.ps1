Import-Module -Name Pester -MinimumVersion 5.3.3
$config = [PesterConfiguration]::Default
$config.Filter.Tag = "Required"
$config.Output.Verbosity = 'Detailed'
$config.Run.PassThru = $true
Invoke-Pester -Configuration $config | Export-NUnitReport -Path Last-TestsReport.NUnitXml