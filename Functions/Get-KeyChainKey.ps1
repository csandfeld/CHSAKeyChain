function Get-KeyChainKey {
    param(
      [Parameter(Mandatory=$false)]
      [String]
      $Key
      ,

      [Parameter(Mandatory=$false)]
      [String]
      $KeyChain = "$env:USERPROFILE\Documents\WindowsPowerShell\KeyChain.xml"
    )
    
    Try {

        Write-Verbose 'Import KeyChain'
        $KeyChainKeys = Import-Clixml -Path $KeyChain -ErrorAction Stop
        $all_good = $true

    }
    Catch {
    
        Throw
        $all_good = $false

    }

    if ($all_good) {
    
        if ($Key) {
            
            $KeyChainKeys.GetEnumerator() | Where-Object { $_.Name -eq $Key } 
    
        }
        else {
        
            $KeyChainKeys
        
        }
        
    }
}