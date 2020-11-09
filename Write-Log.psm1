<#
.SYNOPSIS
    Module to write log-files
.DESCRIPTION
    This module writes log-files in the folder 'Logs'.
    The Folder will be created, if it does not exist yet.
.EXAMPLE
    PS C:\> Import-Module ".\Modules\Write-Log.psm1" -Force
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

enum SeverityLevel {
    Info = 0
    Warning = 1
    Error = 2
    TerminatingError = 3
}


function Write-Log {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param (
        [Parameter(Mandatory = $true)][Alias("Msg")]
        [string]$Message,
        [Parameter(Mandatory = $false)][Alias("Sev")]
        [SeverityLevel]$Severity = [SeverityLevel]::Info,
        [Parameter(Mandatory = $false)]
        [string]$LogPath = "C:\Temp\Log.log"
    )
    $Date = Get-Date -UFormat "%d.%m.%Y %H:%M:%S"

    $ErrString = ""
    if ($IsError) {
        $ErrString = "Error: "
    } 
    if ($Terminating) {
        $ErrString = "Terminating $ErrString"
    }
    $LogMsg = "[$Date]`t$ErrString$Message"
    switch ($Severity) {
        "Warning" { $Color = "Yellow"; break }
        "Error" { $Color = "Red"; break }
        "TerminatingError" { $Color = "DarkRed"; break }
        Default { $Color = "Green"; break }
    }
    Write-Host $LogMsg -ForegroundColor:$Color
}