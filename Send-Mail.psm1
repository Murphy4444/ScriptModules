<#
.SYNOPSIS
    Module to send E-Mails
.DESCRIPTION
    This module provides the function "Send-Mail".
    It sends E-Mails.
    For further Description, Get Help directly from the function after importing it:
    Get-Help Send-Mail
.EXAMPLE
    PS C:\> Import-Module ".\Modules\Send-Mail.psm1" -Force
    Imports the Module to use in the script
.NOTES
    Author:         Murphy4444
    Creation Date:  16. Nov 2020
#>

enum MailSpec {
    Informational = 0
    Error = 1
}
function Send-Mail {
    <#
    .SYNOPSIS
    Function to send E-Mails
    .DESCRIPTION
    This function sends E-Mails From and To specified E-mail-Address
    Additionally, the MailType can be specified to be either Informational or Error
    The Body of the Mail will change accordingly
    .EXAMPLE
    PS C:\> Send-MailMessage -Spec Error -Information "An Error occured" -SmtpServer smtp.mail.com -Sender  me@mail.com -Recipient you@mail.com -LOGPath "C:\Temp\log.log"
    .INPUTS
    SmtpServer, Sender Address, Recipient Address, LogPath and optionally the Mail Specification and the Information / Text in the Mail
    .PARAMETER Specification
    Can be one of the following Types:
     - Informational
     - Error

    .NOTES
    Author:         Murphy4444
    Creation Date:  16. Nov 2020
    #>


    param(
        [Parameter(Mandatory = $false)][Alias("Spec")]
        [MailSpec]$Specification = [MailSpec]::Informational,
        [Parameter(Mandatory = $false)][Alias("Info")]
        $Information,
        [Parameter(Mandatory = $true)]
        [string]$SmtpServer,
        [Parameter(Mandatory = $true)]
        [string]$Sender,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $false)]
        [string]$ScriptName = ((Get-PSCallStack)[0].Command),
        [Parameter(Mandatory = $true)]
        [string]$LOGPath 


    )
    # $ScriptName
    
    $Subject = "$ScriptName - $Specification Mail"
    switch ($Specification) {
        "Informational" { $MailInfo = "The Script '$ScriptName' ran into (a) problems(s).<br/>$Information"; break }
        "Error" { $MailInfo = "The Script '$ScriptName' ran into (a) problems(s):<br/>$($Information -join '<br/>')"; break }
        Default { $MailInfo = "$Information"; break }
    }
    
    $Body = @"
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <style>
            body {
                font-family:"Arial"
            }
            </style>
        </head>
        <body>
            $MailInfo
            For further information, consult the log file at <b>$LOGFilePath</b>
            Thank you and kind regards
            $Sender
        </body>    
    </html>
"@  
    Write-Log -Message "Sending Mail to $ErrorMailRecipient"

    # [System.IO.File]::WriteAllText("c:\temp\errmsg.html", $Body)
    try {
        Send-MailMessage -From $Sender -SmtpServer $SmtpServer -Subject $Subject -To $Recipient -BodyAsHtml $Body -ErrorAction Stop
    }
    catch {
        Write-Log -Message "Mail could not be sent. ErrorMessage: $($_.Exception.Message)" -Severity Error
    }
}