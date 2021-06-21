#
# Script to detect the existence of Indexsinas (NSABuffMiner) IoCs on an infected machine
#

#Requires -Version 2.0


$ErrorActionPreference = "silentlycontinue"

$IndexsinasFound = $false

# IoCs
$SERVICE_NAMES = "MicrosoftMysql", "MicrosoftMssql", "MicrosotMaims", "MicrosotMais", "serivces"
$USER_NAME = "mm123$"
$FONTS_MYSQL = "C:\Windows\Fonts\Mysql"
$FILE_PATHS = "C:\Windows\c64.exe", "C:\Windows\86.exe", "C:\Windows\iexplore.exe", "C:\Windows\Temp\xsfxdel~.exe"
$SCHEDULED_TASKS_NAMES = "At1", "At2"


Write-Output "Indexsinas Campaign Detection Tool"
Write-Output "Written By Guardicore Labs"
Write-Output "Contact us at: labs@guardicore.com`n"

# Detect services
$serviceFound = $false
foreach ($sn in $SERVICE_NAMES) {
    
    $serviceFound = Get-Service -Name $sn
    if ($serviceFound) {
        $IndexsinasFound = $true
        Write-Output "[X] Service $sn was found on this host."
    }
    else {
        Write-Output "[V] Indexsinas's malicious service $sn was not found on this host."
    }
}
if (!$serviceFound) {
    Write-Output "[V] No malicious service was found."
}


# Detect Added Local User
$userFound = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$USER_NAME'"
if ($userFound) {
    $IndexsinasFound = $true
    Write-Output "[X] User $USER_NAME was found on this host."
}
else {
    Write-Output "[V] Indexsinas's local user $USER_NAME was not found on this host."
}


# Detect Dropped Payloads
$payloadsFound = $false
foreach ($pn in $FILE_PATHS) {
    if (Test-Path -Path $pn) {
        $IndexsinasFound = $payloadsFound = $true
        Write-Output "[X] A malicious folder / payload was found in $pn."
    }
}
if (!$payloadsFound) {
    Write-Output "[V] No malicious payloads were found."
}


# Check scheduled tasks created by u.exe
$schedtaskFound = $false
foreach ($tn in $SCHEDULED_TASKS_NAMES) {
    $taskObj = schtasks.exe /Query /TN $tn 2>$null
    if ($taskObj) {
        $IndexsinasFound = $schedtaskFound = $true
        Write-Output "[X] A malicious scheduled task '$tn' was found on this host."
    }
    else {
        Write-Output "[V] Indexsinas's scheduled task $tn was not found on this host."
    }
}
if (!$schedtaskFound) {
    Write-Output "[V] No malicious scheduled tasks were found."
}

# Summary
if ($IndexsinasFound) {
    Write-Output "`n[X] Evidence for the Indexsinas campaign has been found on this host."
}
else {
    Write-Output "`n[V] No evidence for the Indexsinas campaign has been found on this host."
}

