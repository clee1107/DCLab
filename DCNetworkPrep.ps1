####################################################################
# Name: DCNetworkPrep.ps1                                          #
# Purpose:                                                         #
#    - Display detected Interfaces for selection                   #
#    - Prompt for IP configuration (IPv4 Only)                     #
#    - Set DNS to local Host (127.0.0.1)                           #
# Notes:                                                           #
#   - Created ChrisLee - 2021Aug09                                 #
####################################################################

# Region - Build Splat Hash
    $IPValues = @{
        AddressFamily="IPv4"
        IPAddress=""
        DefaultGateway=""
        PrefixLength=""
    }
# EndRegion

# Region - Display Interfaces and select desired one
    Get-NetIPInterface | Where-Object {$_.InterfaceAlias -NotLike "*isatap*" -and $_.InterfaceAlia -NotLike "*adapter*" -and $_.InterfaceAlias -NotLike "*Loopback*" -and $_.AddressFamily -eq "IPv4"} | Select-Object -Property @{name='Index';expression={$_.ifIndex}},@{name='Interface';expression={$_.InterfaceAlias}}
    $IfIndex = Read-Host "Select Desired Interface by Index Number"
# EndRegion

# Region - Prompt for Configuration
    $IPAddress = Read-Host "Enter desired IP Address (xxx.xxx.xxx.xxx)"
    $IPValues.IPAddress = $IPAddress
    $DefaultGateway = Read-Host "Enter desired Default Gateway (xxx.xxx.xxx.xxx)"
    $IPValues.DefaultGateway = $DefaultGateway
    $PrefixLength = Read-Host "Enter Subnet as slash notation (ex 24 for 255.255.255.0)"
    $IPValues.PrefixLength = $PrefixLength
# EndRegion

# Region - Set IP settings
    Try {
        Get-NetIPInterface -InterfaceIndex $IfIndex -AddressFamily 'IPv4' | New-NetIPAddress @IPValues
        Write-Host -ForegroundColor Green "Successfully Configured IP Address"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Configure IP Address"
    }
# EndRegion

# Region - Set DNS
    Try {
        Get-NetIPInterface -InterfaceIndex $IfIndex -AddressFamily 'IPv4' | Set-DnsClientServerAddress -ServerAddresses "127.0.0.1"
        Write-Host -ForegroundColor Green "Successfully Configured DNS"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Configure DNS"
    }
# EndRegion