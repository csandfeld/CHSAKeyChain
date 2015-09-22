# Dot-Source function files
"$PSScriptRoot\Functions\*.ps1" | Resolve-Path | ForEach-Object { . $_.ProviderPath }

Export-ModuleMember -Function *
