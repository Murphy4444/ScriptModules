<#
.SYNOPSIS
    Module to write log-files
.DESCRIPTION
    This module provides the function "Write-Log".
    It writes log-files in a specified folder.
    For further Description, Get Help directly from the function after importing it:
    Get-Help Write-Log
.EXAMPLE
    PS C:\> Import-Module ".\Modules\Write-Log.psm1" -Force
    Imports the Module to use in the script
.NOTES
    Author:         Murphy4444
    Creation Date:  09. Nov 2020
#>

enum SeverityLevel {
    Info = 0
    Warning = 1
    Error = 2
    TerminatingError = 3
}


function Write-Log {
    <#
    .SYNOPSIS
    Function to write log-files
    .DESCRIPTION
    This function writes log-files in a specified folder.
    The Folder will be created, if it does not exist yet.
    .EXAMPLE
    PS C:\> Write-Log -Message "This is a log Message" -Severity "Error"
    .INPUTS
    Message, Severity and optionally the LogPath
    .PARAMETER Severity
    Can be one of the following Levels (next to it is the ForeGroundColor that will be displayed):
     - Info             :       Green
     - Warning          :       Yellow
     - Error            :       Red
     - TerminatingError :       DarkRed
    
    .OUTPUTS
    The Provided Message in the according ForeGroundColor
    An Entry in the specified Logfile

    .NOTES
    Author:         Murphy4444
    Creation Date:  09. Nov 2020

    History
    -------
    Author:         Murphy4444
    Date:           07. Jun 2021
    Change Note:    Noticed that script doesn't do what it says it does, so I did something about that.
    #>


    [CmdletBinding(DefaultParameterSetName = 'None')]
    param (
        [Parameter(Mandatory = $true)][Alias("Msg")]
        [string]$Message,
        [Parameter(Mandatory = $false)][Alias("Sev")]
        [SeverityLevel]$Severity = [SeverityLevel]::Info,
        [Parameter(Mandatory = $false)]
        [string]$LogPath = "C:\Temp\Log.log"
    )

    if (!(Test-Path $LogPath)) {
        New-Item -Force $LogPath
    }

    $Date = Get-Date -UFormat "%d.%m.%Y %H:%M:%S"

    $Prefix = ""
    switch ($Severity) {
        "Warning" { $Color = "Yellow"; $Prefix = "Warning: " ; break }
        "Error" { $Color = "Red"; $Prefix = "Error: "; break }
        "TerminatingError" { $Color = "DarkRed"; $Prefix = "Terminating Error: "; break }
        Default { $Color = "Green"; break }
    }
    $LogMsg = "[$Date]`t$Prefix$Message"

    Write-Host $LogMsg -ForegroundColor:$Color
    Add-Content -Value $LogMsg -Path $LogPath
}