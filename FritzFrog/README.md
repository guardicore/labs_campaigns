# Smominru Campaign IoCs

This repository contains a list of IoCs for the [Smominru campaign](https://www.guardicore.com/2019/09/smominru-botnet-attack-breaches-windows-machines-using-eternalblue-exploit).

## Repository Contents
* **Names and hashes of files** dropped as part of the attack
* **Connect-back servers'** domains and IP addresses
* Names of **scheduled tasks and services** set by the attacker
* Names of **WMI objects** created by the attacker
* **Usernames** created by the attacker
* **MS-SQL usernames and jobs** created by the attacker

## Detection Script - *detect_smominru.ps1*
### Running the Script
Open a PowerShell command prompt and run
```
.\detect_smominru.ps1
```
The script detects traces of the campaign's attacks:
1. Payload files in different paths
2. Registry keys
3. Scheduled tasks
4. Services
5. WMI objects

If the machine has any such residues, the output will contain the sentence 
```
Evidence for the Smominru campaign has been found on this host.
```
In such case, you should:
* remove traces of the attack (the payload paths will be printed out)
* remove the malicious service, scheduled tasks and WMI objects
* patch your operating system and choose strong credentials, to avoid reinfection
