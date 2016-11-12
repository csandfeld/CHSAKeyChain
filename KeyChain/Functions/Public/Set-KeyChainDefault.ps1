function Set-KeyChainDefault {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_ -IsValid})]
        $KeyChainFile
    )
    $ConfigHash = @{
        KeyChainFile = $KeyChainFile
    }
    SetConfigData -ConfigHash $ConfigHash -ConfigFile (GetConfigPath -Location Custom)
}
