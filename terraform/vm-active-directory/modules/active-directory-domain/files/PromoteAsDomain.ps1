[CmdletBinding()]

param 
( 
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$domain_name,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$domain_user_upn,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$domain_user_password
)

#
# Install ADDS/GPMC/RSAT(ADTools) Components
#
Add-WindowsFeature AD-Domain-Services, GPMC, RSAT-ADDS, RSAT-AD-PowerShell

#
# Install New Domain Controller
#
Import-Module ADDSDeployment
$Cred = New-Object PSCredential "$domain_user_upn@$domain_name",(ConvertTo-SecureString $domain_user_password -AsPlainText -Force)
$Params = @{
    Credential                    = $Cred;
    DomainName                    = $domain_name;
    SiteName                      = "Default-First-Site-Name";
    DatabasePath                  = "C:\Windows\NTDS";
    LogPath                       = "C:\Windows\NTDS";
    SysvolPath                    = "C:\Windows\SYSVOL";
    ReplicationSourceDC           = "";
    NoGlobalCatalog               = $false;
    CriticalReplicationOnly       = $false;
    SafeModeAdministratorPassword = (ConvertTo-SecureString $domain_user_password -AsPlainText -Force);
    InstallDns                    = $true;
    CreateDnsDelegation           = $false;
    NoRebootOnCompletion          = $false;
    Confirm                       = $false;
}
Install-ADDSDomainController @Params