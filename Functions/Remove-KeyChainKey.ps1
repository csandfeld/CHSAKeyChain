function Remove-KeyChainKey {
    param(
      [Parameter(Mandatory=$true)]
      [String]
      $Key
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
            $KeyChainKeys = Import-Clixml -Path $KeyChain -ErrorAction Stop
            $all_good = $true

        }
        Catch {
        
            Throw
            $all_good = $false

        }
    }

    
    if ($all_good) {
        
        if ($KeyChainKeys.Count -gt 0) {
            #$KeyChainKeys = @{$KeyChainKeys.GetEnumerator() | Where-Object { $_.Key -ne $Key }}
            $KeyChainKeys.Remove($Key)
        }

        if ($KeyChainKeys.Count -gt 0) {
            $AllKeys += $KeyChainKeys
        }

        Try {
        
            $AllKeys | Export-Clixml -Path $KeyChain
        
        }
        Catch {
        
            Throw
        
        }
    
    }
}
