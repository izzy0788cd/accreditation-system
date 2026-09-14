$env:HOST_IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" -and $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
Write-Host "Using LAN IP: $env:HOST_IP"
docker compose up --build -d