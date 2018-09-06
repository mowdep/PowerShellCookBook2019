# Recipe 1.5 - Creating an internal PowerShell repository

https://kevinmarquette.github.io/2017-05-30-Powershell-your-first-PSScript-repository/


# 1. Create repository folder
$LPATH = 'C:\RKRepo'
New-Item -Path $LPATH -ItemType Directory -ErrorAction SilentlyContinue 
    Out-Null

# 2. Share the folder for others
New-SmbShare -Name RKRepo -Path $LPATH -Description 'RK Repo' -FullAccess 'Everyone'

# 3. Create the repository as trusted
$Path = '\\SRV1\RKRepo'
$REPOHT = @{
  Name               = 'RKRepo'
  SourceLocation     = $Path
  PublishLocation    = $Path
  InstallationPolicy = 'Trusted'
}
Register-PSRepository @REPOHT

# 4. View configured repositories
Get-PSRepository

# 5. Create a Hello World module folder
New-Item C:\HW -ItemType Directory

# 6. And Create a very simple module
$HS = @"
Function Get-HelloWorld {'Hello World'}
Set-Alias GHW Get-HelloWorld
"@
$HS | Out-File C:\HW\HW.psm1

# 7. Load and test the Module
Import-Module -Name c:\hw -verbose
GHW

# 8. Create a Manifest for the new modle
$NMHT = @{
  Path              = 'C:\HW\HW.psd1' 
  RootModule        = 'HW.psm1' 
  Description       = 'Hello World module' 
  Author            = 'DoctorDNS@Gmail.com' 
  FunctionsToExport =  'Get-HelloWorld'
}

# 9. Publish the module:
Publish-Module -Path C:\HW -Repository RKRepo

# 10. See the results of publishing
Find-Module -Repository RKRepo

# 11. See repo folder
Get-ChildItem -Path C:\RKRepo

