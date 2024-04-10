New-LocalGroup -Name "RemoteDesktopGroup"

$logonRight = New-Object System.Security.Principal.FileSystemAccessRule("RemoteDesktopGroup", "RemoteInteractiveLogon", "Allow")
Add-LocalGroupMember -Group "RemoteDesktop Users" -Member $logonRight


