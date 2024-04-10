# Define the subnet to scan (modify this to your specific subnet)
$Subnet = "192.168.0"

# Function to test connectivity and get hostname (if possible)
function Get-DeviceInfo {
  param(
    [Parameter(Mandatory=$true)]
    [string] $IpAddress
  )

  $pingResult = Test-Connection -ComputerName $IpAddress -Count 1 -Quiet
  if ($pingResult.IsSuccess) {
    $hostName = [System.Net.Dns]::GetHostEntry($IpAddress).HostName
    return [PSCustomObject]@{
      IPAddress = $IpAddress
      Hostname = if ($hostName -ne $IpAddress) { $hostName } else { "N/A" }
    }
  }
  return $null
}

# Loop through each IP and use Get-DeviceInfo function
$Devices = @()
for ($i = 1; $i -le 254; $i++) {
  $ipAddress = "$Subnet.$i"
  $device = Get-DeviceInfo -IpAddress $ipAddress
  if ($device) {
    $Devices += $device
  }
}

# Additionally, use ARP to find MAC addresses (may require admin rights)
if ((Get-Verb -Command arp).Name) {
  $arpEntries = Get- arp -Address "*"
  foreach ($arpEntry in $arpEntries) {
    $ipAddress = $arpEntry.IPAddress
    $macAddress = $arpEntry.MACAddress
    $existingDevice = $Devices | Where-Object { $_.IPAddress -eq $ipAddress }
    if (!$existingDevice) {
      $Devices += New-Object PSCustomObject -Property @{
        IPAddress = $ipAddress
        Hostname = "N/A (ARP)"
        MACAddress = $macAddress
      }
    } else {
      $existingDevice.MACAddress = $macAddress
    }
  }
}

# Display results
if ($Devices) {
  Write-Host "Discovered Devices:"
  $Devices | Format-Table IPAddress, Hostname, MACAddress -AutoSize
} else {
  Write-Host "No devices found on the subnet."
}
