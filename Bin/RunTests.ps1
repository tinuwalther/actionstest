Import-Module -Name Pester -MinimumVersion 5.3.3
$config = [PesterConfiguration]::Default
$config.Filter.Tag = "Required"
$config.Output.Verbosity = 'Detailed'
Invoke-Pester -Configuration $config