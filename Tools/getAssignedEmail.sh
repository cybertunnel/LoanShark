#!/bin/bash
#####################
# LoanShark Get Assigned User Email
# -----------------------
# This script will get the assigned user's email address that was given during the loaner assignment.
#####################

#   Commands
awk="/usr/bin/awk"
sudo="/usr/bin/sudo"
echo="/bin/echo"

#   Variables
loanshark_path="/Library/Application Support/LoanShark/LoanShark.app/Contents/MacOS/LoanShark"
loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

if [ -f "${loanshark_path}" ]; then
    user_email=$($sudo -u "${loggedInUser}" "${loanshark_path}" --loanee-details | ${awk} -F 'of' '{print $4}' | ${awk} -F '.' '{$NF="";print $0}' | awk '{$1=$1;print}')
    $echo "<result>$user_email</result>"
    exit 0
else
    $echo "LoanShark is not installed on this system."
    exit 1
fi

exit 0