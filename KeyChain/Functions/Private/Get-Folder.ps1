function Get-Folder {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ -IsValid })]
        [System.String[]]
        $Path
        ,
        [Switch]
        $Create
        #= $false
    )
    process {
        foreach ($p in $Path) {
            $ResolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p)
            if (-not (Test-Path $ResolvedPath -PathType Container) ) {
                if ($Create) {
                    New-Item -Path $ResolvedPath -ItemType Directory
                }
            } else {
                Get-Item -Path $ResolvedPath
            }
        }
    }
}
