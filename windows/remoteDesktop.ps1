param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('Enable', 'Disable', 'Help')]
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
elseif ($Action -eq 'Help') {
    Write-Host "Usage: script.ps1 -Action <Enable|Disable|Help>"
    Write-Host "  -Action <Enable|Disable|Help> : Enable or disable Remote Desktop or show usage information."
}
else {
    Write-Host "Invalid action. Please use 'Enable', 'Disable', or 'Help'."
}
