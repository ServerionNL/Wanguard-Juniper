#!/bin/bash  
# Wanguard Script to gathering and update prefixes from Juniper devices
# Serverion.com - 2022
loc=Los_Angeles
sho=lax

 echo $'1. Logging in at '$loc' Router...OK'
 sleep 1
 sshpass -f p ssh oxidized@rtr001.$sho.serverion.com   'show configuration routing-options aggregate | grep route | display set | grep "/2[0-4]"' | grep '/' |  awk '{ p>
 echo $'2. Logged in and gathering routed prefixes...OK'

 echo $'3. Prefixes found in Juniper routing table in '$loc'...OK'
 sleep 1
   cat $loc.txt
 
 echo $"4. Prefixes found in Wanguard...OK"
   php /opt/andrisoft/api/cli_api.php ipzone "$loc" list | grep Internal | awk '{ print $1 }' > '$loc'_current.txt
   cat '$loc'_current.txt 
 sleep 1

 echo $'5. Removing prefixes from Wanguard...OK'
  for i in $(cat '$loc'_current.txt); do
   php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" delete > /dev/null
  done

 echo $'6. Inserting new routes in Wanguard API and linking thresholds...OK'
 for i in $(cat $loc.txt); do
    php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" add > /dev/null
    php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" set_ip_group "Internal Zone" > /dev/null
    php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" set_thresholds_template "Thresholds" > /dev/null
    php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" set_ip_graphs "Off" > /dev/null
    php /opt/andrisoft/api/cli_api.php ipzone "$loc" subnet "$i" set_ip_accounting "Off" > /dev/null
 done
 sleep 1
 rm -rf $loc.txt
 rm -rf '$loc'_current.txt
 echo 'All done!'



