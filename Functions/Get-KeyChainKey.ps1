#requires -Version 2

<#
        .SYNOPSIS
        Gets all Keys or a specific Key (a label and a credential object) from a KeyChain file
        .DESCRIPTION
        The Get-KeyChainKey function is used to get one or all keys in a KeyChain file.
        The credential objects use the Data Protection Application Programming Interface (DPAPI) to encrypt the password.
        The DPAPI stores the encryption key in the user profile.
        For more about DPAPI see https://msdn.microsoft.com/en-us/library/ms995355.aspx
        .EXAMPLE
        Get-KeyChainKey

        Gets all keys contained in the KeyChain file in the default location ($env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml).
        .EXAMPLE
        Get-KeyChainKey -Key 'TEST1'

        Gets the 'TEST1' key contained in the KeyChain file in the default location ($env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml).
        .EXAMPLE
        Get-KeyChainKey -Key 'TEST2' -KeyChain 'C:\My\Custom\KeyChain\File.xml'

        Gets the 'TEST2' key from a KeyChain file in a custom location.
        .INPUTS
        System.String
        .OUTPUTS
        Deserialized.System.Collections.Hashtable
        .LINK
        https://github.com/csandfeld/KeyChain
#>
function Get-KeyChainKey
{
    param(
        # The name of the key you want to get
        [Parameter(Mandatory = $false)]
        [String]
        $Key = ''
        ,
        
        # The full path to a custom KeyChain XML file (any name will do)
        [Parameter(Mandatory = $false)]
        [String]
        $KeyChain = "$env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml"
    )
    
    Try 
    {
        Write-Verbose -Message "Import KeyChain: $KeyChain"
        $KeyChainKeys = Import-Clixml -Path $KeyChain -ErrorAction Stop
        $all_good = $true
    }
    Catch 
    {
        Throw
        $all_good = $false
    }

    if ($all_good) 
    {
        if ($Key -ne '') 
        {
            Write-Verbose -Message "Return specific key: $Key"
            if ($KeyChainKeys[$Key]) 
            {
                @{
                    $Key = $KeyChainKeys[$Key]
                }
            }
            else 
            {
                $null
            }
        }
        else 
        {
            Write-Verbose -Message 'Return all keys'
            $KeyChainKeys
        }
    }
}

