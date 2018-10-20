# https://docs.microsoft.com/en-us/azure/active-directory/active-directory-accessmanagement-groups-settings-cmdlets


#  Office 365 Groups naming policy
#  https://support.office.com/en-us/article/Office-365-Groups-naming-policy-6ceca4d3-cad1-4532-9f0f-d469dfbbb552

Uninstall-Module AzureADPreview

Install-Module AzureADPreview

Import-Module AzureADPreview

Connect-AzureAD

#############################################
# Licensing
#
#  Group naming policy requires Azure active directory Premium P1 license for unique users that are members of Office 365 groups.
#############################################


#  Supported Azure AD attributes are [Department], [Company], [Office], 
#         [StateOrProvince], [CountryOrRegion], [Title], [CountryCode]
#    During policy creation, the total prefixes and suffixes string length is restricted to 53 characters

# Need to include [GroupName] to indicate where user-entered value goes...

$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id
$Setting["PrefixSuffixNamingRequirement"] = "Grp_[GroupName]"


# The blocked words check is done after appending the prefixes and suffixes to the user entered group name. 
# So if user enters ‘s**t’ and ‘Prefix_’ is the naming policy, ‘Prefix_s**t’ will pass. 
# But if the naming policy is ‘Prefix<space>‘, ‘Prefix s**t’ will fail. Consider this while choosing the right prefixes and suffixes.

$Setting["CustomBlockedWordsList"]="Payroll,CEO,HR"


#
#
#

$Setting["ClassificationList"] = "High,Medium,Low"
Set-UnifiedGroup <LowImpactGroup@constoso.com> -Classification <LowImpact> 

Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting