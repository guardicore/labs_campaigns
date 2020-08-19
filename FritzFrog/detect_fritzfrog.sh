#!/bin/bash

echo "FritzFrog Detection Script by Guardicore Labs"
echo -e "=============================================\n"

proc_names=( "nginx" "ifconfig" "libexec" "php-fpm" )
malicious_proc=false
listening_port=false

for pn in "${proc_names[@]}"
do
    exe_path=$(ls -l /proc/$(pidof $pn)/exe 2>/dev/null | grep deleted)
    if [[ $exe_path ]]; then
        malicious_proc=true
        echo "[*] Fileless process" $pn "is running on the server."
    fi
done

if [[ $(netstat -ano | grep LISTEN | grep 1234) ]]; then
    listening_port=true
    echo "[*] Listening on port 1234"
fi

if $malicious_proc || $listening_port; then
    echo "[*] There is evidence of FritzFrog's malicious activity on this machine."
    exit 1
else
    echo "[*] The machine seems clean."
    exit 0
fi
