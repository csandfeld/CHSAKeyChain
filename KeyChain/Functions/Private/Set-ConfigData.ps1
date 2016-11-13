function Set-ConfigData {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $ConfigHash
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigFile
    )
    $ErrorActionPreference = 'Stop'
    Try {
        [void](Get-Folder -Create (Split-Path -Path $ConfigFile -Parent))
        $ConfigHash | ConvertTo-Json -Depth 99 | Out-File -FilePath $ConfigFile -Force -Confirm:$false
    }
    Catch {
        Throw
    }
}
