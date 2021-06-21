# Indexsinas (NSABuffMiner) Campaign IoCs

This repository contains a list of IoCs and a detection tool for the [Indexsinas campaign]().

## Repository Contents
* **Names and hashes of files** dropped as part of the attack
* **Source IP addresses** from which attacks on Guardicore Global Sensors Network (GGSN) were seen
* Domain names of **connect-back machines**
* Other **Host IOCs** such as services, scheduled tasks and users created as part of the attack

## Detection Script - *detect_indexsinas.ps*
### Running the Script
Open a Windows Powershell prompt and run
```
./detect_indexsinas.ps
```
The script checks whether one of the host IOCs is present on the machine.
If so, there's a high chance the machine is infected and the script will alert on that.

```
PS C:\labs_campaigns\Indexsinas> .\detect_indexsinas.ps1
Indexsinas Campaign Detection Tool
Written By Guardicore Labs
Contact us at: labs@guardicore.com

[V] Indexsinas's malicious service MicrosoftMysql was not found on this host.
[V] Indexsinas's malicious service MicrosoftMssql was not found on this host.
[V] Indexsinas's malicious service MicrosotMaims was not found on this host.
[V] Indexsinas's malicious service MicrosotMais was not found on this host.
[V] Indexsinas's malicious service serivces was not found on this host.
[V] No malicious service was found.
[V] Indexsinas's local user mm123$ was not found on this host.
[V] No malicious payloads were found.
[V] Indexsinas's scheduled task At1 was not found on this host.
[V] Indexsinas's scheduled task At2 was not found on this host.
[V] No malicious scheduled tasks were found.

[V] No evidence for the Indexsinas campaign has been found on this host.
```

In such case, you should:
* remove the malicious services, scheduled tasks and backdoor users
* terminate Indexsinas-related processes
* segment traffic to SMB servers in your network

You are welcome to [contact us](mailto:labs@guardicore.com) for assistance with mitigating the threat.
