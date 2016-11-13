function Get-ConfigPath {
    [CmdletBinding()]
    Param(
        [ValidateSet('Custom','Default','Validated')]
        $Location = 'Validated'
    )
    
    # Set child path part
    $ChildPath = Join-MultiPath -Path $ModuleDefault.ConfigData, $ModuleDefault.ConfigFile
    
    # Custom Config path
    $CustomConfigPath = Join-MultiPath -Path $env:LOCALAPPDATA, $ModuleDefault.ModuleName, $ChildPath
    
    # Default Config path
    $DefaultConfigPath = Join-MultiPath -Path $ModuleDefault.ModuleRoot, $ChildPath
    
    # Decide what to return
    Switch ($Location) {
        'Custom'    { $ConfigPath = $CustomConfigPath }
        'Default'   { $ConfigPath = $DefaultConfigPath }
        'Validated' {
            if (Test-Path -Path $CustomConfigPath) {
                $ConfigPath = $CustomConfigPath
            }
            elseif (Test-Path -Path $DefaultConfigPath) {
                $ConfigPath = $DefaultConfigPath
            }
            else {
                Write-Error -Message 'Config file not found'
            }
        }
    }
    return $ConfigPath
}
