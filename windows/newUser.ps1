$user = Read-Host "Enter username: " -MaskCharacter "*"

$Password = Read-Host "Enter password: " -AsSecureString

$params = @{
  Name        = $user
  Password    = $Password
  FullName    = "Some User"
  Description = "Description of this account."
}

New-LocalUser @params

$addToRemoteDesktopGroup = Read-Host "Add user to 'RemoteDesktopGroup' (y/N)? " -AsSingleCharacter

if ($addToRemoteDesktopGroup -eq "y" -or $addToRemoteDesktopGroup -eq "Y") {
  Add-LocalGroupMember -Group "Remote Desktop Users" -Member $user
  Write-Host "User '$user' added to the 'Remote Desktop Users' group."
} else {
  Write-Host "User '$user' created without adding to the 'Remote Desktop Users' group."
}
