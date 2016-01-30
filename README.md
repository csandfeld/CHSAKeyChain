[![Build status](https://ci.appveyor.com/api/projects/status/275dnejcjtf4vmg3?svg=true)](https://ci.appveyor.com/project/csandfeld/keychain)

# About KeyChain

KeyChain is a simple module you can use to store credentials for later use.
The module simply assign a key (a tag or label if you will) to a credential
object, and store the object in an XML file, made with the Export-CliXml.

Credentials are stored by exporting PSCredential objects to XML with the
Export-CliXml Cmdlet.

The PSCredential object use the Data Protection Application Programming 
Interface (DPAPI) to encrypt the password, alowing only the user account
that entered the password to decrypt it. The encryption key is stored in 
the user profile. Thus credentials exported to an XML file are safe from
prying eyes.

For more about the KeyChain module see:
https://github.com/csandfeld/KeyChain/blob/master/Culture/about_KeyChain.help.txt

For more about DPAPI see:
https://msdn.microsoft.com/en-us/library/ms995355.aspx
