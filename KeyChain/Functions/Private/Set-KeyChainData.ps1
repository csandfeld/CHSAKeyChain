function Set-KeyChainData {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $KeyChainData
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $KeyChainFile
    )
    $ErrorActionPreference = 'Stop'
    Try {
        [void](Get-Folder -Create (Split-Path -Path $KeyChainFile -Parent))
        $KeyChainData | Export-Clixml -Path $KeyChainFile -Force -Confirm:$false
    }
    Catch {
        Throw
    }
}
