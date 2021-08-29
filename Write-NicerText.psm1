<#
.SYNOPSIS
    Module to display text in a nicer way
.DESCRIPTION
    This module provides the multiple functions to nisplay Text in a nicer way.
    Such as to underline or box in the specified Text
    To get a list of functions made available with this module, execute:
    Get-Module Write-NicerText
    For further description, Get Help directly from a function after importing the Module it:
    Get-Help Write-Title
.EXAMPLE
    PS C:\> Import-Module ".\Write-NicerText.psm1" -Force
    Imports the Module to use in the script

.NOTES
    Author:         Murphy4444
    Creation Date:  27.08.2021
#>



function Write-Title {
    <#
    .SYNOPSIS
    Function to display text in a nice box
    .EXAMPLE
    PS C:\> Write-Title -TitleText "Very nice title" -XSpacing 3 -SidePadding 2 -Symbol "#"
    #########################
    ##   Very nice title   ##
    #########################   
    PS C:\>

    .NOTES
    Author:         Murphy4444
    Creation Date:  29.08.2021
#>
    [CmdletBinding(DefaultParameterSetName = 'Symbol')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TitleText,
        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$Color = [System.ConsoleColor]::White,
        [Parameter(Mandatory = $false, ParameterSetName = 'Symbol')]
        [uint32]$SidePadding = 1,
        [Parameter(Mandatory = $false, ParameterSetName = 'Symbol')]
        [uint32]$VerticalPadding = 1,
        [Parameter(Mandatory = $false)]
        [uint32]$XSpacing = 1,
        [Parameter(Mandatory = $false)]
        [switch]$Center,
        [Parameter(Mandatory = $false)]
        [uint32]$YSpacing = 0,
        [Parameter(Mandatory = $false, ParameterSetName = 'Symbol')]
        [char]$Symbol = "*",
        [Parameter(Mandatory = $false, ParameterSetName = 'ASCIIDouble')]
        [switch]$ASCIIDouble,
        [Parameter(Mandatory = $false, ParameterSetName = 'ASCIISingle')]
        [switch]$ASCIISingle
    )

    if ($Center) { 
        $WindowWidth = $Host.UI.RawUI.WindowSize.Width
        $XSpacing = [System.Math]::Floor(($WindowWidth - $TitleText.Length) / 2) - $SidePadding
    } 

    $SymbolAmount = $TitleText.Length + 2 * $XSpacing
    if ($ASCIISingle) {
        if ($YSpacing -ne 0) {
            $Y_Filler = "`n│$(" "*($TitleText.Length + 2 * $XSpacing))│" * $YSpacing
        }
        Write-Host -ForegroundColor $Color @"
┌$("─"*$SymbolAmount)┐$Y_Filler
│$(" "*$XSpacing)$TitleText$(" "*$XSpacing)│$Y_Filler
└$("─"*$SymbolAmount)┘
"@
        return
    }
    if ($ASCIIDouble) {
        if ($YSpacing -ne 0) {
            $Y_Filler = "`n│$(" "*($TitleText.Length + 2 * $XSpacing))│" * $YSpacing
        }
        Write-Host -ForegroundColor $Color @"
╔$("═"*$SymbolAmount)╗$Y_Filler
║$(" "*$XSpacing)$TitleText$(" "*$XSpacing)║$Y_Filler
╚$("═"*$SymbolAmount)╝
"@
        return
    }

    $SymbolAmount = $TitleText.Length + 2 * $SidePadding + 2 * $XSpacing
    if ($YSpacing -ne 0) {
        $Y_Filler = "`n$("$Symbol"*$SidePadding)$(" "*($TitleText.Length + 2 * $XSpacing))$("$Symbol"*$SidePadding)" * $YSpacing
    }
    if ($VerticalPadding -ge 1) {
        $VPadding = "$Symbol" * $SymbolAmount + "`n$("$Symbol" * $SymbolAmount)" * ($VerticalPadding - 1)
    }
    Write-Host -ForegroundColor $Color @"
$VPadding$Y_Filler
$("$Symbol"*$SidePadding)$(" "*$XSpacing)$TitleText$(" "*$XSpacing)$("$Symbol"*$SidePadding)$Y_Filler
$VPadding
"@
}

function Write-UnderlinedText {
    <#
    .SYNOPSIS
    Function to display underlined text
    .EXAMPLE
    PS C:\> Write-UnderlinedText -Text "Very nice text" -SidePadding 2
      Very nice text  
    ------------------
    PS C:\>

    .NOTES
    Author:         Murphy4444
    Creation Date:  27.08.2021
#>
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Text,
        [System.ConsoleColor]$Color = [System.ConsoleColor]::White,
        [Parameter(Mandatory = $false)]
        [uint32]$Spacing = 1,
        [Parameter(Mandatory = $false)]
        [switch]$Center,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Single", "Double")]
        [string]$Line = "Single"
    )

    if ($Center) { 
        $WindowWidth = $Host.UI.RawUI.WindowSize.Width
        $Spacing = [System.Math]::Floor(($WindowWidth - $Text.Length) / 2)
    }

    $LineAmount = $Text.Length + 2 * $Spacing
    switch ($Line) {
        "Single" { $Symbol = "-"; break }
        "Double" { $Symbol = "="; break }
    }
    Write-Host -ForegroundColor $Color @" 
$(" "*$Spacing)$Text$(" "*$Spacing)
$("$Symbol"*$LineAmount)
"@
}