# Nansh0u Campaign IoCs 🐢

This repository contains a list of IoCs for the [Nansh0u campaign](link_to_post).

## Repository Contents 
* The lists of **common usernames and passowrds** used to break into _MSSQL_ servers
* **Names of files** dropped as part of the attacks
* **MD5 hashes** of the payloads downloaded as part of the attacks
* **IP addresses** of both attackers and connect-backs
* **Domains** of mining pools connected-to by the miner malware
* The attacker's *TRTLCoin* **aallet address** 
* a **Powershell script** made by Guardicore to detect residues of the Nansh0u campaign on a Windows machine

## Detection Script - *detect_nansh0u.ps1*
### Running the Script
Open a PowerShell command prompt and run
```
.\detect_nansh0u.ps1
```
The script detects traces of the campaign's attacks:
1. Payload files in `c:\ProgramData\`
2. Registry run-keys
3. The driver `SA6482`

If the machine has any such residues, the output will contain the sentence 
```
Evidence for Nansh0u campaign has been found on this host.
```
In such case, you should:
* remove traces of the attack from `C:\ProgramData\`
* remove the malicious driver
* terminate the miner process
