function Remove-ConfigData {
<#
    .SYNOPSIS
        Removes custom configuration data file.
#>
    [CmdletBinding(SupportsShouldProcess)]
    Param ()
    $ConfigPath = Get-ConfigPath -Location Custom
    if (Test-Path -Path $ConfigPath) {
        if ($PSCmdlet.ShouldProcess($ConfigPath)) {
            Write-Verbose -Message "Removing custom configuration file: $ConfigPath"
            Remove-Item -Path $ConfigPath -Force -Confirm:$false
        }
    }
}
