#
# Script to detect the existence of Smominru IoCs on an infected machine
#

#Requires -Version 2.0


$ErrorActionPreference = "silentlycontinue"

$SmominruFound = $false

# IoCs
$SERVICE_NAME = "xWinWpdSrv"
$USER_NAME = "admin$"
$FILTER_NAME = "fuckyoumm3"
$CONSUMER_NAME = "fuckyoumm4"
$UPSUPX_DOWNLOADED_PAYLOADS = "C:\Windows\debug\lsmose.exe", "C:\Windows\debug\lsmos.exe", "C:\Windows\debug\lsmo.exe", "C:\Program Files (x86)\Common Files\csrw.exe", "C:\Program Files\Common Files\csrw.exe", "c:\windows\help\lsmosee.exe", "c:\csrs.exe", "C:\Windows\debug\item.dat", "C:\Program Files\Common Files\xpdown.dat", "C:\Program Files\Common Files\xpwpd.dat"
$NAMESERVER_REGISTRY = (Get-ItemProperty -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces").NameServer
$SCHEDULED_TASKS_NAMES = "my1", "Mysa", "Mysa1", "Mysa2", "Mysa3", "ok"


Write-Output "Smominru-Campaign Detection Tool"
Write-Output "Written By Guardicore Labs"
Write-Output "Contact us at: labs@guardicore.com`n"


# Detect service
$serviceFound = Get-Service -Name $SERVICE_NAME
if ($serviceFound) {
    $SmominruFound = $true
    Write-Output "[X] Service $SERVICE_NAME was found on this host"
}
else {
    Write-Output "[V] Smominru's malicious service $SERVICE_NAME was not found on this host"
}


# Detect Added Local User
$userFound = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$USER_NAME'"
if ($userFound) {
    $SmominruFound = $true
    Write-Output "[X] User $USER_NAME was found on this host"
}
else {
    Write-Output "[V] Smominru's local user $USER_NAME was not found on this host"
}

# Detect WMI Objects
$fuckyoumm3Found = Get-WmiObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='$FILTER_NAME'"
$fuckyoumm4Found = Get-WmiObject -Namespace root\Subscription -Class CommandLineEventConsumer -Filter "Name='$CONSUMER_NAME'"
if ($fuckyoumm3Found -or $fuckyoumm4Found) {
    $SmominruFound = $true
    Write-Output "[X] a malicious WMI object was found on this host"
}
else {
    Write-Output "[V] Smominru's WMI objects were not found on this host"
}


# Detect Dropped Payloads
$payloadsFound = $false
foreach ($pn in $UPSUPX_DOWNLOADED_PAYLOADS) {
    if ([System.IO.File]::Exists($pn)) {
        $SmominruFound = $payloadsFound = $true
        Write-Output "[X] A malicious payload was found in $pn"
    }
}
if (!$payloadsFound) {
    Write-Output "[V] No malicious payloads were found"
}


# Check nameserver in registry (set by u.exe)
$maliciousValue = '223.5.5.5,8.8.8.8'
if ($NAMESERVER_REGISTRY -eq $maliciousValue) {
    $SmominruFound = $true
    Write-Output "[X] A suspicious Nameserver value '$maliciousValue' was found in this host's registry"
}
else {
    Write-Output "[V] No malicious Nameserver entry was found in this host's registry"
}


# Check scheduled tasks created by u.exe
$schedtaskFound = $false
foreach ($tn in $SCHEDULED_TASKS_NAMES) {
    $taskObj = schtasks.exe /Query /TN $tn 2>$null
    if ($taskObj) {
        $SmominruFound = $schedtaskFound = $true
        Write-Output "[X] A malicious scheduled task '$tn' was found on this host"
    }
}
if (!$schedtaskFound) {
    Write-Output "[V] No malicious scheduled tasks were found"
}

# Summary
if ($SmominruFound) {
    Write-Output "`n[X] Evidence for the Smominru campaign has been found on this host"
}
else {
    Write-Output "`n[V] No evidence for the Smominru campaign has been found on this host"
}

