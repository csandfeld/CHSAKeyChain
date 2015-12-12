$ModuleName = 'KeyChain';

if (!$PSScriptRoot) { # $PSScriptRoot is not defined in 2.0

    $PSScriptRoot = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)

}



Describe "$ModuleName module" {

    $ModuleRoot = (Resolve-Path "$PSScriptRoot\..").Path

    #Import-Module (Join-Path -Path $ModuleRoot -ChildPath "$ModuleName.psd1") -Force
    
    
    # Get temporary KeyChain file name
    $KeyChain = Join-Path -Path $TestDrive -ChildPath 'TmpKeyChain.xml'
    
    
    while ($int -le 2) {
        $int++
    
        # Create PSCredenial object
        $Key        = "TEST$int"
        $UserName   = "Username$int"
        $Password   = "Password$int" | ConvertTo-SecureString -asPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential($UserName,$Password)
        
        It "Add-KeyChainKey should return nothing when adding $Key key" {
        
            Add-KeyChainKey -KeyChain $KeyChain -Key $Key -Credential $Credential | Should be $null
        
        }
    
    }
    
    
    
    It 'Get-KeyChainKey should throw when key chain file does not exist' {
    
        { Get-KeyChainKey -KeyChain "$TestDrive\FileDoesNotExist.xml" } | Should Throw
    
    }
    
    
    
    It "Get-KeyChainKey should return all ($int) keys when no key is specified" {
    
        (Get-KeyChainKey -KeyChain $KeyChain).Count | Should be $int
        
    }
    
    
    
    It 'Get-KeyChainKey should return correct object type when no key is specified' {
    
        (Get-KeyChainKey -KeyChain $KeyChain).GetType() | Should be 'hashtable'
        
    }
    
    
    
    It 'Get-KeyChainKey should return correct object type when key is specified' {
    
        (Get-KeyChainKey -KeyChain $KeyChain -Key TEST1).GetType() | Should be 'System.Collections.DictionaryEntry'
    
    }
    
    
    
    It 'Get-KeyChainKey should return expected username' {
        
        (Get-KeyChainKey -KeyChain $KeyChain -Key TEST1).Value.UserName | Should be 'Username1'
    
    }
    
    
    
    It 'Remove-KeyChainKey should return nothing when removing a key' {
    
        Remove-KeyChainKey -KeyChain $KeyChain -Key FAKEKEY | Should be $null
    
    }
    
    
    
    It 'Remove-KeyChainKey should remove key from key chain' {
    
        Remove-KeyChainKey -KeyChain $KeyChain -Key TEST1
        Get-KeyChainKey -KeyChain $KeyChain -Key TEST1 | Should be $null
    
    }
}