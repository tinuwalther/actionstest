# ./Bin/New-BranchContent.ps1 -BranchName 'Test123' -BodyContent 'Test Test Test' -verbose
[CmdletBinding()]
param(
    #region parameter, to add a new parameter, copy and paste the Parameter-region
    [Parameter(
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position = 0
    )]
    [String] $BranchName,
    #endregion,

    [Parameter(
        Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position = 1
    )]
    [String] $BodyContent
)

process{
    $ret = $null # or @()
    $StartTime = Get-Date
    $function = $($MyInvocation.MyCommand.Name)
    Write-Verbose $('[', (Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), ']', '[ Process ]', $function -Join ' ')

    try{
        $RootFolder = $PSScriptRoot | Split-Path -Parent
        $NodeFolder = Join-Path -Path $RootFolder -ChildPath 'Nodes'
        $ExampleYaml = Join-Path -Path $NodeFolder -ChildPath "$($BranchName).yml"
        Write-Verbose "[ $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff') ] [ Path    ] $($ExampleYaml)"
        $CurrentLocation = Get-Location
        Set-Location $NodeFolder

        if(Test-Path $ExampleYaml){
            $CommitMessage = "Update $($BranchName).yml"
        }else{
            $CommitMessage = "Add $($BranchName).yml"
        }
        Write-Verbose "[ $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff') ] [ Branch  ] $($BranchName)"
        if(-not([String]::IsNullOrEmpty($BodyContent))){
            Add-Content -Path $ExampleYaml "# $($BodyContent)"
        }
        Add-Content -Path $ExampleYaml "- Name:      $($BranchName)"
        Add-Content -Path $ExampleYaml "  IPAddress: 192.x.y.z"
        Add-Content -Path $ExampleYaml "  Subnet:    255.255.255.0"
        Add-Content -Path $ExampleYaml "  Gateway:   192.x.y.1"
        Add-Content -Path $ExampleYaml "  Status:    new"

        Set-Location $CurrentLocation
        Write-Verbose "[ $(Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff') ] [ Commit  ] $($CommitMessage)"
        $ret = $CommitMessage
    }catch{
        Write-Warning $('ScriptName:', $($_.InvocationInfo.ScriptName), 'LineNumber:', $($_.InvocationInfo.ScriptLineNumber), 'Message:', $($_.Exception.Message) -Join ' ')
        $Error.Clear()
    }

    finally{
        Write-Verbose $('[', (Get-Date -f 'yyyy-MM-dd HH:mm:ss.fff'), ']', '[ End     ]', $function -Join ' ')
        $TimeSpan  = New-TimeSpan -Start $StartTime -End (Get-Date)
        $Formatted = $TimeSpan | ForEach-Object {
            '{1:0}h {2:0}m {3:0}s {4:000}ms' -f $_.Days, $_.Hours, $_.Minutes, $_.Seconds, $_.Milliseconds
        }
        Write-Verbose $('Finished in:', $Formatted -Join ' ')
    }
    return $ret

}
