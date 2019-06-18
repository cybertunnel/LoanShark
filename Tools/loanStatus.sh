#!/bin/bash
#####################
# LoanShark Status
# -----------------------
# This script will help give results of the loan status to MDM software.
#####################

app_exec="/Library/Application Support/LoanShark/Contents/MacOS/LoanShark"

status=$(${app_exec} --status)

echo "<result>${status}</result>"

exit 0