
# Autodiscovering the great leak

This repository contains a list of Autodiscover domains with all possible TLDs and a mapping to 127.0.0.1 to be included in your local *hosts* file. Read our blogpost about [Autodiscovering the great leak](https://www.guardicore.com/labs/autodiscovering-the-great-leak/).

## Repository Contents
* **autodiscover-tlds.txt** list of all possible autodiscover.[tld] combinations and a mapping to 127.0.0.1 to be pasted into your local *hosts* file

## Implementing the contents of this file
The local *hosts* file gives you the ability to override DNS resolutions. 
A hostname in the *hosts* file will be resolved to the IP address was hardcoded in the file. The contents of this file are mapping all possible autodiscover.[tld] domains to be resolved as 127.0.0.1 in order to keep credentials from leaking outside of your network.

Various operating systems have their *hosts* file in a different localtion:

Windows:
```
%windir%\System32\drivers\etc\hosts
```
Linux and macOS:
```
/etc/hosts
```

Append the contents of **autodiscover-tlds.txt** to your local *hosts* file.
