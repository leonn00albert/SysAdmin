param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('Enable', 'Disable')]
    [string]$Action
)

function Enable-RD {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
}

function Disable-RD {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1
    Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
}

if ($Action -eq 'Enable') {
    Enable-RD
    Write-Host "Remote Desktop has been enabled."
}
elseif ($Action -eq 'Disable') {
    Disable-RD
    Write-Host "Remote Desktop has been disabled."
}
else {
    Write-Host "Invalid action. Please use 'Enable' or 'Disable'."
}
