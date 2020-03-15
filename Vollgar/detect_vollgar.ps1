#
# Script to detect the existence of Vollgar IoCs on an infected machine
#

#Requires -Version 2.0


$ErrorActionPreference = "silentlycontinue"

$VollgarFound = $false

# IoCs
$SERVICE_NAME = "SQLAGENT MSSQL SQLIOSIMSA"
$USER_NAME = "IUER_SERVER"
$ADMIN_TEMP = "C:\Users\Administrator\AppData\Local\Temp"
$FILE_PATHS = "C:\ProgramData\wget.vbs", "C:\ProgramData\SQLAGENTIDC.exe", "C:\RECYCLER\SQLAGENTIDC.exe", "C:\SQLAGENTIDC.exe", "C:\RECYCLER\wget.vbs", "C:\RECYCLER\SQLAGENTIDC.exe", "C:\ProgramData\SQLAGENTIDC.exe", "C:\SQLAGENTIDC.exe", "C:\ProgramData\emsda.vbs", "C:\RECYCLER\emsda.vbs", "$ENV:TEMP\SQLAGENTSWA.exe", "$ENV:TEMP\SQLIOMDSD.exe", "$ENV:TEMP\SQLSernsf.exe", "C:\Program Files (x86)\Microsoft SQL Server\SQLSerasi.exe", "startas.bat", "C:\Users\MSSQL~1\AppData\Local\Temp\startas.bat", "C:\Users\MSSQLSERVER\AppData\Local\Temp\startas.bat", "C:\Windows\Temp\startas.bat", "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp\startas.bat", "$ADMIN_TEMP\startas.bat", "$ADMIN_TEMP\1\startas.bat", "$ADMIN_TEMP\2\startas.bat", "$ADMIN_TEMP\3\startas.bat", "$ADMIN_TEMP\4\startas.bat", "$ADMIN_TEMP\5\startas.bat", "startae.bat", "C:\Users\MSSQL~1\AppData\Local\Temp\startae.bat", "C:\Users\MSSQLSERVER\AppData\Local\Temp\startae.bat", "C:\Windows\Temp\startae.bat", "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp\startae.bat", "$ADMIN_TEMP\startae.bat", "$ADMIN_TEMP\1\startae.bat", "$ADMIN_TEMP\2\startae.bat", "$ADMIN_TEMP\3\startae.bat", "$ADMIN_TEMP\4\startae.bat", "$ADMIN_TEMP\5\startae.bat"
$SCHEDULED_TASKS_NAMES = ".NET Framework NGEN v0.2.212294", ".NET Framework NGEN v0.2.212294 64", ".NET Framework NGEN v0.2.213394", ".NET Framework NGEN v0.2.213394 64", ".NET Framework NGEN v0.2.214294", ".NET Framework NGEN v0.2.214294 64", ".NET Framework NGEN v0.2.215394", ".NET Framework NGEN v0.2.215394 64"


Write-Output "Vollgar Campaign Detection Tool"
Write-Output "Written By Guardicore Labs"
Write-Output "Contact us at: labs@guardicore.com`n"


# Detect service
$serviceFound = Get-Service -Name $SERVICE_NAME
if ($serviceFound) {
    $VollgarFound = $true
    Write-Output "[X] Service $SERVICE_NAME was found on this host"
}
else {
    Write-Output "[V] Vollgar's malicious service $SERVICE_NAME was not found on this host"
}


# Detect Added Local User
$userFound = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$USER_NAME'"
if ($userFound) {
    $VollgarFound = $true
    Write-Output "[X] User $USER_NAME was found on this host"
}
else {
    Write-Output "[V] Vollgar's local user $USER_NAME was not found on this host"
}


# Detect Dropped Payloads
$payloadsFound = $false
foreach ($pn in $FILE_PATHS) {
    if ([System.IO.File]::Exists($pn)) {
        $VollgarFound = $payloadsFound = $true
        Write-Output "[X] A malicious payload was found in $pn"
    }
}
if (!$payloadsFound) {
    Write-Output "[V] No malicious payloads were found"
}


# Check scheduled tasks created by u.exe
$schedtaskFound = $false
foreach ($tn in $SCHEDULED_TASKS_NAMES) {
    $taskObj = schtasks.exe /Query /TN $tn 2>$null
    if ($taskObj) {
        $VollgarFound = $schedtaskFound = $true
        Write-Output "[X] A malicious scheduled task '$tn' was found on this host"
    }
}
if (!$schedtaskFound) {
    Write-Output "[V] No malicious scheduled tasks were found"
}

# Summary
if ($VollgarFound) {
    Write-Output "`n[X] Evidence for the Vollgar campaign has been found on this host"
}
else {
    Write-Output "`n[V] No evidence for the Vollgar campaign has been found on this host"
}

