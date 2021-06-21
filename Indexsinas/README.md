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
ubuntu@ip-111-11-11-11:~$ ./detect_fritzfrog.sh
FritzFrog Detection Script by Guardicore Labs
=============================================

[*] Fileless process nginx is running on the server.
[*] Listening on port 1234
[*] High chances FritzFrog is running on this machine.
```

In such case, you should:
* remove the malicious services, scheduled tasks and backdoor users
* terminate Indexsinas-related processes
* segment traffic to SMB servers in your network

You are welcome to [contact us](mailto:labs@guardicore.com) for assistance with mitigating the threat.
