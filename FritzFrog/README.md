# FritzFrog Campaign IoCs 🐸

This repository contains a list of IoCs and a detection tool for the [FritzFrog campaign](https://www.guardicore.com/2020/08/fritzfrog).

## Repository Contents
* **Names and hashes of files** dropped as part of the attack
* **Source IP addresses** from which attacks on Guardicore Global Sensors Network were seen
* IP addresses of **connect-back machines**, allegedly infected by the malware
* **Public SSH key** used by the attacker as a backdoor

## Detection Script - *detect_fritzfrog.sh*
### Running the Script
Open a Linux terminal and run
```
.\detect_fritzfrog.sh
```
The script detects checks whether:
1. A fileless process named _nginx / ifconfig / libexec / php-fpm_ is running
2. Port 1234 is listening

If two of these conditions hold, there's a high chance the machine is infected.

```
ubuntu@ip-111-11-11-11:~$ ./detect_fritzfrog.sh
FritzFrog Detection Script by Guardicore Labs
=============================================

[*] Fileless process nginx is running on the server.
[*] Listening on port 1234
[*] High chances FritzFrog is running on this machine.
```

In such case, you should:
* kill the malicious processes
* block traffic on ports 1234 (P2P communication) and 5555 (cryptominer)
* block traffic to domain `xmrpool.eu`

You are welcome to [contact us](mailto:labs@guardicore.com) for assistance with mitigating the threat.
