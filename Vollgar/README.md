# Vollgar Campaign IoCs

This repository contains a list of IoCs for the [Vollgar campaign](https://www.guardicore.com).

## Repository Contents
* Names of **binary files and script** dropped as part of the attack
* **Connect-back servers'** domains and IP addresses
* Names of **scheduled tasks and services** set by the attacker
* **Backdoor credentials** created by the attacker
* a **Powershell script** made by Guardicore to detect residues of the Vollgar campaign on a Windows machine

## Detection Script - *detect_vollgar.ps1*
### Running the Script
Open a PowerShell command prompt and run
```
.\detect_volgar.ps1
```
The script detects traces of the campaign's attacks:
1. Payload files in various file-system locations
2. Services and scheduled task names
3. Backdoor usernames

If the machine has any such residues, the output will contain the sentence 
```
Evidence for Vollgar campaign has been found on this host.
```
In such case, you should:
* remove traces of the attack from the paths specified in the output
* terminate the malicious processes
* contact [Guardicore Labs](mailto:labs@guardicore.com)