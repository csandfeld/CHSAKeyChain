function Set-KeyChainDefault {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_ -IsValid})]
        $KeyChainFile
    )
    $ConfigHash = @{
        KeyChainFile = $KeyChainFile
    }
    Set-ConfigData -ConfigHash $ConfigHash -ConfigFile (Get-ConfigPath -Location Custom)
}
