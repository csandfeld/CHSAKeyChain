function JoinPath {
    <#
            .SYNOPSIS
            Joins any number of elements into a path
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.String[]]$Path
    )
    begin {
        $JoinPath = ''
    }
    process {
        foreach ($p in $Path) {
            if ($JoinPath -eq '') {
                $JoinPath = $p
            } else {
                $JoinPath = Join-Path -Path $JoinPath -ChildPath $p
            }
        }
    }
    end {
        return [System.String]$JoinPath
    }
}
