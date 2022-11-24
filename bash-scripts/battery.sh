#!/bin/bash

# ----- Create Battery_Charge_Notification with Crontab----

User=$(whoami) &&

touch /home/$User/.Battery_Charge_Notification.sh &&

echo '#!/bin/bash' > /home/$User/.Battery_Charge_Notification.sh &&

echo "# Description: Display notification if battery is about to charge or discharge fully." >> /home/$User/.Battery_Charge_Notification.sh &&

echo "
# upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|to\ full|percentage\" ;  --- There are different ways we get battery status - this is no 1
# upower -i $(upower -e | grep 'BAT') | grep -E \"state|to\ full|percentage\" | awk '/perc/{print \$2}' --- There are different ways we get battery status - this is no 2
# \$ find /sys/class/power_supply/BAT0/ -type f | xargs -tn1 cat --- There are different ways we get battery status - this is no 3
# \$ cat /sys/class/power_supply/BAT0/status --- There are different ways we get battery status - this is no 4
# \$ cat /sys/class/power_supply/BAT0/capacity --- There are different ways we get battery status - this is no 5

# we will try to use 4th & 5th ; as only these gives one letter / number as output. Rest gives long string and also baterry % in long string , cannot be used to compare arithmatically


# Set state variable = 
cat /sys/class/power_supply/BAT0/status
	if [ \$? -eq 0 ]; then state=\$(cat /sys/class/power_supply/BAT0/status) ;
		else state=\$(cat /sys/class/power_supply/BAT1/status) ;
	fi ; 


# Set capacity variable = 
cat /sys/class/power_supply/BAT0/capacity
	if [ \$? -eq 0 ]; then percent=\$(cat /sys/class/power_supply/BAT0/capacity) ;
		else percent=\$(cat /sys/class/power_supply/BAT1/capacity) ;
	fi ;	

state_1=\"Charging\" ;	
percent_1=\"90\" ;

state_2=\"Discharging\" ;
percent_2=\"30\" ;

rm \$percent_1 # I do not know why, but running this script creates a file named of \"percent_1\" field value. rm \$percent_1 removes that file.
rm \$percent_2 # I do not know why, but running this script creates a file named of \"percent_2\" field value. rm \$percent_2 removes that file.


#### play_beep = \$(play -q -n synth 0.2 sin 880 >& /dev/null)
#### play -q -n synth 0.1 sin 880 ---> Changing the 0.1 will change the length of the sound, Changing sin 880 will adjust the pitch ... lots of possibilities! 


# ------- Overcharging Protection ------- 
if [ \$state = \$state_1 ];
then
		if [ \$percent -gt \$percent_1 ];
		then
			(notify-send -i /usr/share/icons/gnome/22x22/devices/battery.png \"Battery is almost CHARGED = \$percent %\" \"Disconnect power supply to improve battery life\" ; \$(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say \"Disconnect Charger\" || speak \"Disconnect Charger\" ; rm \$percent_1)
		else rm \$percent_1 ; exit 0
		fi
# ------- Discharging Protection ------- 
else
	if [ \$state = \$state_2 ];
	then
		if [ \$percent -lt \$percent_2 ];
		then
			(notify-send -i /usr/share/icons/gnome/22x22/devices/ac-adapter.png \"Battery is about to DISCHARGE = \$percent % remaining\" \"Connect power supply to continue\" ; \$(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say \"Connect Charger\" || speak \"Connect Charger\" ; rm \$percent_2)
		else rm \$percent_2 ; exit 0
		fi
	else rm \$percent_2 ; exit 0
	fi
fi
exit 0

# Further instructions -

# ------- Save the script in /home/USERNAME  &  Add the script in crontab to run-----
# In the terminal type command :- chmod 777 /home/Replace_by_USERNAME/Battery_Charge_Notification.sh # replace actual username
# in the terminal type command :-  crontab -e
# add following parameters at the end of file (uncomment to enable)

#### Min Hour Day Month DayOfWeek Command
# DISPLAY=\":0.0\"
# XAUTHORITY=\"/home/$User/.Xauthority\"
#### In above Line, replace actual username in place of $User. Delete THIS line after that.
# XDG_RUNTIME_DIR=\"/run/user/1000\"
# MAILTO=''

# add following cron schedule below the parameters (uncomment to enable) to run the script in every 10 min.
#*/10 * * * * bash /home/$User/.Battery_Charge_Notification.sh >/dev/null 2>&1 # replace actual username

# ------- End ---------

" >> /home/$User/.Battery_Charge_Notification.sh && chmod 777 /home/$User/.Battery_Charge_Notification.sh &&


# ----- Add Battery Charge Notification to Crontab ----

User=$(whoami) &&

#write out current crontab
touch ~/myTEMPcron ;
crontab -l >> ~/myTEMPcron ;
#echo new cron into cron file

echo "
# Edit this file to introduce tasks to be run by cron.
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
# Format - Minute(0-59) Hour(24 Hr format) Day(of Month 1-31)  Month(1-12) Day(of week 1-7)
#### Min Hour Day Month DayOfWeek Command
#
#
# Special Characters---->    * = Any Value | , = value list separator | - = range of values | / = step values  
# Non-standard characters ----> @yearly | @annually | @monthly | @weekly | @daily | @hourly | @reboot
# -----------------------------------------------------------------------
# To add a new crontab schedule , in terminal type crontab -e
# To list all crontab schedule , in terminal type crontab -l
# To remove all crontab schedule , in terminal type crontab -r
# ----------------------------------------------------------------------
#
# Command Examples ---> 
# run Login_log.sh at every alternate minute
# */2 * * * * sh /home/$User/scripts/Login_log.sh
#
# run Login_log.sh at 30 seconds after every reboot
# @reboot sleep 30 && sh /home/$User/scripts/Login_log.sh
# 0 */3 * * * sh /path_to_script/backup_script.sh >/dev/null 2>&1 # Runs backup once in 3 Hrs

# --------------------- Actual Cron Jobs Are Following -------------------------

DISPLAY=\":0.0\"
XAUTHORITY=\"/home/$User/.Xauthority\"
XDG_RUNTIME_DIR=\"/run/user/1000\"
MAILTO=\"\"

*/5 * * * * bash /home/$User/.Battery_Charge_Notification.sh >/dev/null 2>&1 # battery charge notification

" >> ~/myTEMPcron ;

install new cron file

cat ~/myTEMPcron | crontab - ;
rm ~/myTEMPcron &&

sleep 1 ;

echo "Crontab Schedule is added successfully for /home/$User/.Battery_Charge_Notification.sh" ;

echo "It will check status every 5 min and alert you for appropriate action. Like ..." ;

sleep 1 ;

echo "When battery is about to get FULLY CHARGED..." ;
sleep 1 ;
notify-send -i /usr/share/icons/gnome/22x22/devices/battery.png "Battery is almost CHARGED = Percent %" "Disconnect power supply to improve battery life" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Disconnect Charger" || speak "Disconnect Charger" ;

sleep 2 ;

echo "And, when battery is about to get discharged ..." ;
sleep 1;
notify-send -i /usr/share/icons/gnome/22x22/devices/ac-adapter.png "Battery is about to DISCHARGE = Percent % remaining" "Connect power supply to continue" ; $(play -q -n synth 0.2 sin 880 >& /dev/null) ; sleep 1 ; spd-say "Connect Charger" || speak "Connect Charger" ;

sleep 2;

echo "For more details check the script ---
/home/$User/.Battery_Charge_Notification.sh
----
Thank you" ;

sleep 5 ;

exit 0

