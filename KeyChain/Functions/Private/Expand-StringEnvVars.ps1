function Expand-StringEnvVars {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]
        $InputObject
    )
    process {
        foreach ($Property in ( $InputObject.psobject.Properties | Where-Object { (($_.MemberType -eq 'NoteProperty') -and ($_.IsSettable -eq $true) -and ($_.Value.GetType() -eq [System.String] )) } ) ) {
            $Property.Value = [System.Environment]::ExpandEnvironmentVariables($Property.Value)
        }
        return $InputObject
    }
}
