function Reset-KeyChainDefault {
    [CmdletBinding(SupportsShouldProcess)]
    Param ()
    Remove-ConfigData
}
