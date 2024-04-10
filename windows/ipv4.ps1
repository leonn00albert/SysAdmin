# List IPv4 interfaces
$IPv4Interfaces = Get-NetIPInterface -AddressFamily IPv4

# Check if any IPv4 interfaces are found
if ($IPv4Interfaces) {
    Write-Host "IPv4 Interfaces:"
    foreach ($interface in $IPv4Interfaces) {
        Write-Host "Interface Index: $($interface.InterfaceIndex)"
        Write-Host "Interface Alias: $($interface.InterfaceAlias)"
        Write-Host "Interface Description: $($interface.InterfaceDescription)"
        Write-Host "Interface State: $($interface.InterfaceState)"
        Write-Host "IPv4 Address: $($interface.IPv4Address)"
        Write-Host "IPv4 Default Gateway: $($interface.IPv4DefaultGateway)"
        Write-Host "------------------------------------------------"
    }

    do {
        $InterfaceIndex = Read-Host "Enter the Interface Index to configure (leave blank to exit)"
        $SelectedInterface = $IPv4Interfaces | Where-Object { $_.InterfaceIndex -eq $InterfaceIndex }
        if (-not $SelectedInterface) {
            Write-Host "Invalid Interface Index. Please try again."
        }
    } while (-not $SelectedInterface -and -not [string]::IsNullOrWhiteSpace($InterfaceIndex))

    if ($SelectedInterface) {
        Write-Host "Selected Interface: $($SelectedInterface.InterfaceAlias)"

        if ($SelectedInterface.IPv4Address) {
            Write-Host "Removing existing IPv4 configuration..."

        }
        Set-NetIPInterface -InterfaceIndex $SelectedInterface.InterfaceIndex -Dhcp Enabled
        $IPAddress = Read-Host "Enter IP Address (e.g., 192.168.1.230)"
        $PrefixLength = Read-Host "Enter Prefix Length (e.g., 24)"
        
        # Check if default gateway is already set
         $DefaultGateway = Read-Host "Enter Default Gateway (leave blank if none)"
        if ([string]::IsNullOrWhiteSpace($DefaultGateway)) {
            New-NetIPAddress -InterfaceIndex $SelectedInterface.InterfaceIndex -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $PrefixLength 

        }else{
                    New-NetIPAddress -InterfaceIndex $SelectedInterface.InterfaceIndex -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway

        }


        $DNSAddresses = @()
        do {
            $DNSAddress = Read-Host "Enter DNS Server Address (leave blank to finish)"
            if (-not [string]::IsNullOrWhiteSpace($DNSAddress)) {
                $DNSAddresses += $DNSAddress
            }
        } while (-not [string]::IsNullOrWhiteSpace($DNSAddress))

        if ($DNSAddresses.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceIndex $SelectedInterface.InterfaceIndex -ServerAddresses $DNSAddresses
            Write-Host "DNS server addresses set to: $($DNSAddresses -join ', ')"
        }
        else {
            Write-Host "No DNS server addresses provided."
        }
    } else {
        Write-Host "Exiting script."
    }
} else {
    Write-Host "No IPv4 interfaces found."
}
