

# $directory takes the directory for the currently logged in user. Same as "C:\users\'logged in user'"
$directory = $ENV:UserProfile



# The $users variable takes an AD group and places the members into an array
$users = Get-ADGroupMember -Identity  "<group name goes here>" 



# Using $userlist variable, we will make another array out of the users array.
# Thinking about it this way makes me angry... An array out of an array, but it works.
# The difference is that for each member of the requested group, it uses the SamAccountName
# to search by, adds filter if enabled user - select the DisplayName, email, firstname, and lastname
# properties in the new array
$userlist = foreach ($user in $users)

    {
        $user = [string]$user.SamAccountName
        get-aduser -filter {(SamAccountName -eq $user) -and (Enabled -eq $true)} -Properties DisplayName, emailAddress, GivenName, SurName, SamAccountName  | 
        Select-Object DisplayName, emailAddress, GivenName, SurName, SamAccountName
    }


#export the array to a csv
$userlist | Export-Csv $directory\GroupMemberADProperties.csv -NoTypeInformation
