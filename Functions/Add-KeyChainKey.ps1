#requires -Version 3

<#
        .SYNOPSIS
        Adds a Key (a label and a credential object) to a KeyChain file
        .DESCRIPTION
        The Add-KeyChainKey function is used to add or update a set of credentials to a key in a KeyChain file (or update an existing key).
        The credential objects use the Data Protection Application Programming Interface (DPAPI) to encrypt the password.
        The DPAPI stores the encryption key in the user profile.
        For more about DPAPI see https://msdn.microsoft.com/en-us/library/ms995355.aspx
        .EXAMPLE
        Add-KeyChainKey -Key 'TEST1' -UserName 'domain\username'

        Prompts for a password for the 'domain\username' user, assigns the credential set to the 'TEST1' key, and adds (or updates) the 'TEST1' key in the KeyChain file in the default location ($env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml).
        .EXAMPLE
        Add-KeyChainKey -Key 'TEST2' -Credential $Cred

        Assign the credenial object in $Cred to the 'TEST2' key, and adds (or updates) the 'TEST2' key in the KeyChain file in the default location ($env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml).
        .EXAMPLE
        Add-KeyChainKey -Key 'TEST3' -Credential $Cred -KeyChain 'C:\My\Custom\KeyChain\File.xml'

        Assign the credenial object in $Cred to the 'TEST3' key, and adss (or updates) the 'TEST3' key in the KeyChain file in a custom location.
        .INPUTS
        System.String
        System.Management.Automation.PSCredential
        .OUTPUTS
        System.IO.FileInfo
        .LINK
        https://github.com/csandfeld/KeyChain
#>
function Add-KeyChainKey 
{
    param(
        # A unique name for the key. Use this name to refer to your key when you want to use it or remove it.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key
        ,

        # The user name part of a credential object. When supplying a user name, you will be prompted to supply a password.
        [Parameter(Mandatory = $true, ParameterSetName = 'UserName')]
        [System.String]
        $UserName
        ,

        # A full credential object
        [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential]
        $Credential
        ,

        # The full path to where you want to store your KeyChain XML file (any name will do)
        [Parameter(Mandatory = $false)]
        [System.String]
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
