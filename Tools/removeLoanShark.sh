#!/bin/bash
#####################
# LoanShark Uninstall
# -----------------------
# This script will remove all components of LoanShark, and unload the Daemon associated with LoanShark
#####################

#   LoanShark Files
preferences="/Library/Preferences/com.github.cybertunnel.LoanShark.plist"
loan_period_preference="com.github.cybertunnel.LoanShark.plist"
launch_daemon="/Library/LaunchDaemons/com.github.cybertunnel.LoanShark.launch.plist"
old_launch_daemon="/Library/LaunchDaemons/com.github.cybertunnel.launch.plist"
app_folder="/Library/Application Support/LoanShark"
app_name="LoanShark"

#   Commands
rm="rm"
launchctl="/bin/launchctl"
find="/usr/bin/find"
echo="/bin/echo"
killall="/usr/bin/killall"

$echo "Unloading LaunchDaemon..."

if [ -f ${launch_daemon} ]; then
    $launchctl bootout system ${launch_daemon}
elif [ -f ${old_launch_daemon} ]; then
    $echo "Old LaunchDaemon found!"
    $launchctl bootout system ${old_launch_daemon}
else
    $echo "No known LaunchDaemon was found, skipping..."
fi

$echo "Killing LoanShark process(es)..."
$killall ${app_name}

$echo "Deleting LoanShark files..."

if [[ -f ${launch_daemon} || -f ${old_launch_daemon} ]]; then
    $echo "LaunchDaemon..."
    if [ -f ${launch_daemon} ]; then
        $rm ${launch_daemon}
    else
        $rm ${old_launch_daemon}
    fi
else
    $echo "No LaunchDaemon found!"
fi

if [ -f ${preferences} ]; then
    $echo "Preferences..."
    $rm ${preferences}
else
    $echo "No preferences found!"
fi

if [ -d ${app_folder} ]; then
    $echo "LoanShark application folder..."
    $rm -r ${app_folder}
else
    $echo "No LoanShark application folder found!"
fi

$echo "Removing any loan period preferences..."
$find "/Users/" -name ${loan_period_preference} -delete

exit 0
