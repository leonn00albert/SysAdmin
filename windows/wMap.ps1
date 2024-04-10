function Test-Port {
    param (
        [string]$target,
        [int]$port
    )
    
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $connection = $tcpClient.BeginConnect($target, $port, $null, $null)
        $connection.AsyncWaitHandle.WaitOne(1000, $false)
        
        if ($tcpClient.Connected) {
            $tcpClient.EndConnect($connection)
            Write-Host "Port $port is open" -ForegroundColor Green
        } else {
            Write-Host "Port $port is closed" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error occurred while testing port $port : ${_}" -ForegroundColor Yellow
    } finally {
        if ($tcpClient) {
            $tcpClient.Close()
        }
    }
}

function Scan-Ports {
    param (
        [string]$target,
        [int]$startPort,
        [int]$endPort
    )
    
    Write-Host "Scanning ports on $target..."
    
    for ($port = $startPort; $port -le $endPort; $port++) {
        Test-Port -target $target -port $port
    }
}

# Prompt user for input
$target = Read-Host "Enter target hostname or IP address"
$startPort = Read-Host "Enter start port"
$endPort = Read-Host "Enter end port"

# Convert input to appropriate types
$startPort = [int]$startPort
$endPort = [int]$endPort

# Usage example:
Scan-Ports -target $target -startPort $startPort -endPort $endPort
