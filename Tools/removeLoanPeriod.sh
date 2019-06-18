#!/bin/bash
#####################
# LoanShark Reset
# -----------------------
# This script will reset the loan period that has been set on the machine.
#####################

find="/usr/bin/find"
killall="/usr/bin/killall"

app_name="LoanShark"

$find /Users/ -name "com.github.cybertunnel.LoanShark.plist" -delete 2> /dev/null

$killall "${app_name}"

exit 0

