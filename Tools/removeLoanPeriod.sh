#!/bin/bash
#####################
# LoanShark Reset
# -----------------------
# This script will reset the loan period that has been set on the machine.
#####################

$find="/usr/bin/find"

$find /Users/ -name "com.github.cybertunnel.LoanShark.plist" -delete

exit 0

