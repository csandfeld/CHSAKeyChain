#requires -Version 2
function Get-KeyChainKey 
{
    param(
        [Parameter(Mandatory = $false)]
        [String]
        $Key = ''
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
        if ($Key -ne '') 
        {
            Write-Verbose -Message "Return specific key: $Key"
            $KeyChainKeys.GetEnumerator() | Where-Object -FilterScript {
                $_.Name -eq $Key
            }
        }
        else 
        {
            Write-Verbose -Message 'Return all keys'
            $KeyChainKeys
        }
    }
}

