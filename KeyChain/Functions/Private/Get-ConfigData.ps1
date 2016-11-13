function Get-ConfigData {
    Param(
        [Switch]
        $NoEnvExpansion = $false
    )
    $ErrorActionPreference = 'Stop'
    $ConfigPath = Get-ConfigPath
    Try {
        $ConfigData = Get-Content -Path $ConfigPath | ConvertFrom-Json
        if (-not $NoEnvExpansion) {
            $ConfigData = $ConfigData | Expand-StringEnvVars
        }
    }
    Catch {
        Throw
    }
    return $ConfigData
}
