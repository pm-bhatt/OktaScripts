<#
This script will remove group membership of all the de-activated users from your okta tenant. 
Known Limitation : It can work perfectly when your de-activated user count is less then or equal to 200
Author : Pratik Bhatt
#>
<#script version 1.0
Okta API from https://github.com/gabrielsroka/OktaAPI.psm1
Connecting to Okta API #>
Connect-Okta "YOUR TOKEN" "https://youroktadomain.okta.com"
#1. Get all De-activated users ; Getting De-Activated user's llist in Objects
$page = Get-OktaUsers -filter 'status eq "DEPROVISIONED"' # NOTE : This will get only first 200 users in the list
$users = $page.objects
#2. condition in-case there are no de-activated users, print that no deactivated  users are there.
if ($null -eq $users) 
{ 
    Write-Output "No De-activated Users at  $(Get-Date)"
}
#3. if de-activated users are there, then action of removing users from the groups to be performed.; In for loop, remove membership of de-activated users from all group
else 
{
    foreach ($user in $users) 
    {
        $getgroups = Get-OktaUserGroups $user.id
        $groups = $getgroups
        #for ($i = 0; $i -le $groups.Count; $i++) 
        foreach ($group in $groups) 
        {
            if ($null -ne $user.id) #checks if user id is null or not
            {
                if ($null -ne $group.id) #checks if group-id is null or not
                {
                    if ("Everyone" -ne $group.profile.name) #checks if the group name is not everyone,in okta "Everyone" is an inbuilt group for which no user can perform any action on it.
                    {
                        $gid = $group.id
                        $uid = $user.id
                        Remove-OktaGroupMember -groupid $gid -userid $uid   
                    }
                }
            }
        }
        Write-Output "Deleted -> $($user.profile.firstName) $($user.profile.lastName)"                   
    }
}
