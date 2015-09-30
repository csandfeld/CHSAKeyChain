#requires -Version 2
function Get-KeyChainKey 
{
    param(
        [Parameter(Mandatory = $false)]
        [String]
        $Key = $false
        ,

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
        if ($Key -ne $false) 
        {
            Write-Verbose "Return specific key: $Key"
            $KeyChainKeys.GetEnumerator() | Where-Object -FilterScript {
                $_.Name -eq $Key 
            }
        }
        else 
        {
            Write-Verbose 'Return all keys'
            $KeyChainKeys
        }
    }
}

