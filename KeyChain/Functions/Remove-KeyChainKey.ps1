#requires -Version 2

<#
        .SYNOPSIS
        Remove a specific Key (a label and a credential object) from a KeyChain file
        .DESCRIPTION
        The Remove-KeyChainKey function is used to remove a specific key from KeyChain file.
        The credential objects use the Data Protection Application Programming Interface (DPAPI) to encrypt the password.
        The DPAPI stores the encryption key in the user profile.
        For more about DPAPI see https://msdn.microsoft.com/en-us/library/ms995355.aspx
        .EXAMPLE
        Remove-KeyChainKey -Key 'TEST1'

        Removes the 'TEST1' key contained in the KeyChain file in the default location ($env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml).
        .EXAMPLE
        Remove-KeyChainKey -Key 'TEST2' -KeyChain 'C:\My\Custom\KeyChain\File.xml'

        Removes the 'TEST2' key from a KeyChain file in a custom location.
        .INPUTS
        System.String
        .OUTPUTS
        $null
        .LINK
        https://github.com/csandfeld/KeyChain
#>
function Remove-KeyChainKey 
{
    param(
        # The name of the key you want to remove.
        [Parameter(Mandatory = $true)]
        [String]
        $Key
        ,

        # The full path to a custom KeyChain XML file (any name will do)
        [Parameter(Mandatory = $false)]
        [String]
        $KeyChain = (Get-KeyChainDefault).KeyChainFile
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
            $KeyChainKeys = Import-Clixml -Path $KeyChain -ErrorAction Stop
            $all_good = $true
        }
        Catch 
        {
            Throw
            $all_good = $false
        }
    }

    
    if ($all_good) 
    {
        if ($KeyChainKeys.Count -gt 0) 
        {
            #$KeyChainKeys = @{$KeyChainKeys.GetEnumerator() | Where-Object { $_.Key -ne $Key }}
            $KeyChainKeys.Remove($Key)
        }

        if ($KeyChainKeys.Count -gt 0) 
        {
            $AllKeys += $KeyChainKeys
        }

        Try 
        {
            # $AllKeys | Export-Clixml -Path $KeyChain
            $AllKeys | SetKeyChainData -KeyChainFile $KeyChain
        }
        Catch 
        {
            Throw
        }
    }
}
