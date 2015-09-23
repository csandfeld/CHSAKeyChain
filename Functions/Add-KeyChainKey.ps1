function Add-KeyChainKey {
    param(
      [Parameter(Mandatory=$true)]
      [String]
      $Key
      ,

      [Parameter(Mandatory=$true, ParameterSetName='UserName')]
      [String]
      $UserName
      ,

      [Parameter(Mandatory=$true, ParameterSetName='Credential')]
      [System.Management.Automation.PSCredential]
      $Credential
      ,

      [Parameter(Mandatory=$false)]
      [String]
      $KeyChain = "$env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml"
    )
    
    
    # Prepare hash table
    $AllKeys = @{}
    $KeyChainKeys = @{}


    # Check if KeyChain exist
    if (Test-Path -Path $KeyChain -PathType Leaf) {
    
        Write-Verbose "KeyChain found: $KeyChain"

        Try {
        
            Write-Verbose 'Import KeyChain'
            $KeyChainKeys += Import-Clixml -Path $KeyChain -ErrorAction Stop
            $all_good = $true

        }
        Catch {
        
            Throw
            $all_good = $false

        }
    }
    else {

        Write-Verbose "KeyChain not found: $KeyChain"
        $all_good = $true

    }
    
    if ($all_good) {
        
        if ($UserName) {
            Write-Verbose 'Prompt for credential'
            $Credential = Get-Credential $UserName -Message "Enter credential for key: $Key"
        }

        if ($KeyChainKeys.Count -gt 0) {
            $AllKeys += $KeyChainKeys
        }

        $AllKeys[$Key] = $Credential

        Try {
        
            $AllKeys | Export-Clixml -Path $KeyChain
        
        }
        Catch {
        
            Throw
        
        }
    
    }
}
