<#
.DESCRIPTION
    This script finds all OneDrive sites in a tenant and returns a .txt
    file displaying the URL and Sharing Capability for each user. This 
    is useful to check whether any user has custom sharing permissions
    that differ from the global setting.

    At the end is also code to set a custom SharingCapability for a
    specific user's OneDrive.

 Carly Hublou, Microsoft Premier Field Engineer

LEGAL DISCLAIMER:

This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys' fees, that arise or result
from the use or distribution of the Sample Code.
#>

#Connect to your O365 tenant admin SP site with admin credentials.
#Input the admin account UPN; script will prompt you for password at login.
$AdminURI = "https://m365x636297-admin.sharepoint.com"
$AdminAccount = "carlyhublou@cahublou.com"
Connect-SPOService -Url $AdminURI -Credential $AdminAccount

#Create the file to send the data to.
$LogFile = [Environment]::GetFolderPath("Desktop") + "\OneDriveSites.log"

#Grab all SPO sites and filter on the ODFB URL (selecting Owner, SharingCapability, and URL attributes and groubly by SharingCapability) and output to the file you created above.
Get-SPOSite -IncludePersonalSite $true -Filter "Url -like '-my.sharepoint.com/personal/" |Format-Table SharingCapability, Owner, Url -GroupBy SharingCapability | Out-File $LogFile -Force

#Output confirmation of activtiy to the console.
Write-Host "Done! File saved as $($LogFile)."

#OPTIONAL: Set the SharingCapability attribute for a specific user's OneDrive
Set-SPOSite https://m365x636297-my.sharepoint.com/personal/pradeepg_m365x636297_onmicrosoft_com -SharingCapability Disabled
Write-Host "Done! User's SharingCapability updated."