Param($ExposePrivateFunctions)

## Set Global defaults
$ModuleDefault = @{
    ModuleName = 'KeyChain'
    ModuleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
    ConfigData = 'Config'
    ConfigFile = 'Default.json'
}


# Dot-Source function files
"$PSScriptRoot\Functions\*.ps1" | Resolve-Path | ForEach-Object { . $_.ProviderPath }

#Export-ModuleMember -Function *-*


if ($ExposePrivateFunctions) {
    Export-ModuleMember -Function *
}

#@{ DefaultKeyChainFile = '$env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml' } | ConvertTo-Json | Out-File .\Config\Default.json