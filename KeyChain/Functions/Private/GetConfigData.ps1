function GetConfigData {
    Param(
        [Switch]
        $NoEnvExpansion = $false
    )
    $ErrorActionPreference = 'Stop'
    $ConfigPath = GetConfigPath
    Try {
        $ConfigData = Get-Content -Path $ConfigPath | ConvertFrom-Json
        if (-not $NoEnvExpansion) {
            $ConfigData = $ConfigData | ExpandStringEnvVars
        }
    }
    Catch {
        Throw
    }
    return $ConfigData
}
