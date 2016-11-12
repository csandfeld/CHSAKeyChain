## Set Global defaults
$ModuleDefault = @{
    ModuleName = 'KeyChain'
    ModuleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
    ConfigData = 'Config'
    ConfigFile = 'Default.json'
}


$path = "$PSScriptRoot\Functions"
$filter = '*.ps1'
$exclude = @(
    '*.Tests.*',
    '*.Mock.*'
)


function Get-FunctionNameFromAST {
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )
    process{
        foreach ($file in ($InputObject | Where-Object { ($_.Length -gt 0) -and (-not $_.PSIsContainer) } ))
        {
            $AST = [System.Management.Automation.Language.Parser]::ParseInput(
                (Get-Content -Path $file.FullName -Raw),
                [ref]$null,
                [ref]$null
            )
            $AST.FindAll(
                {$args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]},
                $true
            ) |
            Select-Object -ExpandProperty Name
        }
    }
}



# Prepare variable to hold public functions
$publicFunctions = @()

# Dot-Source function files (ignore 0-length files)
$files = Get-ChildItem -Path $path -Filter $filter -Exclude $exclude -Recurse
foreach ($file in ($files | Where-Object { $_.Length -gt 0 }))
{
    # Skip functions in 'Disabled' folder
    if ($file.Directory -notmatch 'Functions\\Disabled$')
    {
        # Dot-Source file
        . $file.FullName
    }

    # Use Abstract Syntax Tree (AST) to collect public functions
    if ($file.Directory -match 'Functions\\Public$')
    {
        $publicFunctions += $file | Get-FunctionNameFromAST
    }
}

Export-ModuleMember -Function $publicFunctions -Alias *
