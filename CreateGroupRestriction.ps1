#  Manage who can create Office 365 Groups
#  https://support.office.com/en-us/article/Manage-who-can-create-office-365-groups-4c46c8cb-17d0-44b5-9776-005fced8e618

Uninstall-Module AzureADPreview

Install-Module AzureADPreview

Import-Module AzureADPreview

Connect-AzureAD

Get-AzureADGroup -Filter "SecurityEnabled eq true"

New-AzureADGroup -DisplayName "Group Creators" -Description "Allowed to create Office 365 Groups" -SecurityEnabled $true -MailEnabled $false -MailNickName "GroupCreators"


$Template = Get-AzureADDirectorySettingTemplate | where {$_.DisplayName -eq 'Group.Unified'}
$Setting = $Template.CreateDirectorySetting()
New-AzureADDirectorySetting -DirectorySetting $Setting

$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id
$Setting["EnableGroupCreation"] = $False
$Setting["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString "Group Creators").objectid

Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting


(Get-AzureADDirectorySetting).Values