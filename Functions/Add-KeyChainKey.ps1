#requires -Version 3

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Add-KeyChainKey 
{
    param(
        # The name of the key. Use this name to refer to your key when you want to use it or remove it,
        [Parameter(Mandatory = $true)]
        [String]
        $Key
        ,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserName')]
        [String]
        $UserName
        ,

        [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential]
        $Credential
        ,

        [Parameter(Mandatory = $false)]
        [String]
        $KeyChain = "$env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml"
    )
    
    
    # Prepare hash table
    $AllKeys = @{}
    $KeyChainKeys = @{}


    # Check if KeyChain exist
    if (Test-Path -Path $KeyChain -PathType Leaf) 
    {
        Write-Verbose -Message "KeyChain found: $KeyChain"

        Try 
        {
            Write-Verbose -Message 'Import KeyChain'
            $KeyChainKeys += Import-Clixml -Path $KeyChain -ErrorAction Stop
            $all_good = $true
        }
        Catch 
        {
            Throw
            $all_good = $false
        }
    }
    else 
    {
        Write-Verbose -Message "KeyChain not found: $KeyChain"
        $all_good = $true
    }
    
    if ($all_good) 
    {
        if ($UserName) 
        {
            Write-Verbose -Message 'Prompt for credential'
            $Credential = Get-Credential -UserName $UserName -Message "Enter credential for key: $Key"
        }

        if ($KeyChainKeys.Count -gt 0) 
        {
            $AllKeys += $KeyChainKeys
        }

        $AllKeys[$Key] = $Credential

        Try 
        {
            $AllKeys | Export-Clixml -Path $KeyChain
        }
        Catch 
        {
            Throw
        }
    }
}
