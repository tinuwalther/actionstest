$config = [PesterConfiguration]::Default
$config.Filter.Tag = "Required"
$config.Output.Verbosity = 'Detailed'
Invoke-Pester -Configuration $config