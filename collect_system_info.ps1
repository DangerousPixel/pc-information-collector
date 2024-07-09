# Temporarily set the execution policy to Bypass for the current process
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Function to get OS information using systeminfo
function Get-OSInfo {
    $osInfo = @{}
    $osDetails = systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
    foreach ($line in $osDetails) {
        if ($line -match '^OS Name:\s+(.+)$') {
            $osInfo["OSName"] = $matches[1]
        } elseif ($line -match '^OS Version:\s+(.+?)\s+Build\s+(\d+)$') {
            $osInfo["OSVersion"] = $matches[1]
            $osInfo["Build"] = "Build $matches[2]"
        }
    }
    return $osInfo
}

# Function to get system information
function Get-SystemInfo {
    $info = [ordered]@{}

    # Get OS info
    $osInfo = Get-OSInfo
    $osName = $osInfo["OSName"]
    $osBuild = $osInfo["Build"]

    # PC information
    $info["pc_name"] = $env:COMPUTERNAME

    # Device information
    $info["domain_status"] = if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain) { "Connected to Domain" } else { "Not Connected to Domain" }
    $info["device_id"] = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
    $info["cpu"] = (Get-WmiObject -Class Win32_Processor).Name
    $totalMemory = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
    $totalMemoryGB = [math]::round($totalMemory / 1GB, 1)
    $info["ram"] = "$totalMemoryGB GB"

    $storageDevices = Get-PhysicalDisk | Select-Object MediaType, Size
    $totalStorageGB = 0
    $storageTypes = @()
    foreach ($device in $storageDevices) {
        $sizeGB = [math]::round($device.Size / 1GB, 1)
        $totalStorageGB += $sizeGB
        $storageTypes += $device.MediaType
    }
    $info["total_storage"] = "$totalStorageGB GB"
    $info["storage_type"] = ($storageTypes -join ' - ')

    # OS information
    $info["windows_version"] = $osName
    $info["windows_build"] = $osBuild
    $info["windows_edition"] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
    $activationStatus = (Get-WmiObject -Query "SELECT LicenseStatus FROM SoftwareLicensingProduct WHERE PartialProductKey IS NOT NULL AND ApplicationID LIKE '55c92734-d682-4d71-983e-d6ec3f16059f'" | Select-Object -ExpandProperty LicenseStatus)
    switch ($activationStatus) {
        0 { $info["activation_status"] = "Unlicensed" }
        1 { $info["activation_status"] = "Licensed" }
        2 { $info["activation_status"] = "Out of Box Grace Period" }
        3 { $info["activation_status"] = "Out of Tolerance Grace Period" }
        4 { $info["activation_status"] = "Non-Genuine Grace Period" }
        5 { $info["activation_status"] = "Notification" }
        6 { $info["activation_status"] = "Extended Grace" }
        Default { $info["activation_status"] = "Unknown" }
    }

    $info["serial_number"] = (Get-WmiObject win32_bios).SerialNumber
    $info["product_id"] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductId

    # User information
    $info["whoami"] = whoami

    return $info
}

# Function to save system information to JSON file
function Save-SystemInfoToJson {
    param (
        [string]$filePath,
        [hashtable]$systemInfo
    )

    if (Test-Path $filePath) {
        $jsonContent = Get-Content -Raw -Path $filePath | ConvertFrom-Json
        if ($jsonContent -isnot [Array]) {
            $jsonContent = @($jsonContent)
        }
        $jsonContent += @($systemInfo)
    } else {
        $jsonContent = @($systemInfo)
    }

    $jsonContent | ConvertTo-Json -Depth 3 | Set-Content -Path $filePath
}

# Main script execution
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$filePath = Join-Path $scriptDir "system_info.json"

$systemInfo = Get-SystemInfo

# Debug information
Write-Output "Collected System Information:"
$systemInfo | Format-List

Save-SystemInfoToJson -filePath $filePath -systemInfo $systemInfo

# Confirm the contents of the JSON file
Write-Output "Contents of the JSON file:"
Get-Content -Path $filePath

Write-Output "System information collected and saved to $filePath"
