#script version 1.0
#Okta API from https://github.com/gabrielsroka/OktaAPI.psm1
#Connecting to Okta API 
Connect-Okta "OKTA API SECRET TOKEN" "YOUR OKTA ORG"
Import-Module OktaAPI
Install-Script CallOktaAPI
#Getting user's list from csv file. Keep CSV File in same folder where this script is
$csv=Import-Csv userlist.csv
function Remove-OktaUserSession($id) {
    $null = Invoke-Method DELETE "/api/v1/users/$id/sessions"
}
foreach ($csvname in $csv)
{
    $id=$csvname.OktaID
    Set-OktaUserExpirePassword $id # This will Expire the user's current password and it will ask end-user to change tha password at next login attempt
    Remove-OktaUserSession $id # This will clear the session for user so they have to forcefully login to okta
}
