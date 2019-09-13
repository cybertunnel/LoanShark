#!/bin/bash
#####################
# LoanShark Launcher
# -----------------------
# Description of script
####################

# Variables
log_location="/Library/Logs/loanshark.log" # Location of where the log will be going.
loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
app="/Library/Application Support/LoanShark/LoanShark.app"
preference_file="/Users/${loggedInUser}/Library/Containers/com.github.cybertunnel.loanshark/Data/Library/Prefernces/com.github.cybertunnel.LoanShark.plist"
plist="/Library/Preferences/com.github.cybertunnel.loanshark.plist"
cp="/bin/cp"
chown="/usr/sbin/chown"

## Commands
defaults="/usr/bin/defaults"
codesign="/usr/bin/codesign --verify"
pgrep="/usr/bin/pgrep"
find="/usr/bin/find"
sudo="/usr/bin/sudo"

## Switches
isAppRunning=true
isFinderRunning=false
isAppInstalled=false
isUserLoggedIn=false

# Functions
## Declare Logging
ScriptLogging()
### NOTE: Usage - $1::(Debug, Info, Error, Fatal, Warn), $2::(Message_String)
{
name="LoanSharkLaunch"

DATE=$(date +%Y-%m-%d\ %H:%M:%S)
LOG="$log_location"

echo "$DATE" \["$name"\] \["$1"\]":" "$2" >> $LOG
echo "$DATE" \["$name"\] \["$1"\]":" "$2"
}

function appInstalled {
  $codesign "${app}" && return 0 || return 1
}

function appNotRunning {
  $pgrep LoanShark && return 1 || return 0
}

function finderRunning {
  $pgrep Finder && return 0 || return 1
}

function loanPeriodSetOtherUser {
  currentUser=$(find /Users/${loggedInUser}/ -name com.github.cybertunnel.LoanShark.plist 2>/dev/null | wc -l)
  ScriptLogging Debug "Found preference files for user: ${currentUser}"

  if [ ${currentUser} -ge 1 ]; then
    ScriptLogging Info "Loan period is set for this user."
  else
    otherUser=$(find /Users/ -name com.github.cybertunnel.LoanShark.plist 2> /dev/null| wc -l)
    ScriptLogging Debug "Found preference files: ${otherUser}"

    if [ ${otherUser} -ge 1 ]; then
      ScriptLogging Warn "Loan period set for another user! >=["

      ScriptLogging Info "Getting valid configuration..."
      plist=$(find /Users/ -name com.github.cybertunnel.LoanShark.plist 2> /dev/null | head -n 1)
      ScriptLogging Debug "Found plist at: $plist"

      ScriptLogging Info "Copying valid configuration..."
      $cp "$plist" "/Users/$loggedInUser/Library/Containers/com.github.cybertunnel.LoanShark/Data/Library/Preferences/com.github.cybertunnel.LoanShark.plist"
      $chown $loggedInUser /Users/$loggedInUser/Library/Containers/com.github.cybertunnel.LoanShark/Data/Library/Preferences/com.github.cybertunne.LoanShark.plist
      $sudo -u $loggedInUser "${app}/Contents/MacOS/LoanShark" --set-expired
    else
      ScriptLogging Info "Loan period not set."
    fi
  fi
}

# Execute
# - DO NOT EDIT BELOW THIS LINE - #
ScriptLogging Info "——— LoanShark Launcher ———"

if appInstalled; then
  ScriptLogging Debug "LoanShark is installed."
else
  ScriptLogging Debug "LoanShark is not installed."
fi

if appNotRunning; then
  ScriptLogging Debug "LoanShark is not running."
else
  ScriptLogging Debug "LoanShark is running."
fi

if finderRunning; then
  ScriptLogging Debug "Finder is running."
else
  ScriptLogging Debug "Finder is not running."
fi

if appInstalled && appNotRunning && finderRunning; then
  ScriptLogging Info "Launching LoanShark."
  $sudo -u "${loggedInUser}" open -a "${app}"
fi

ScriptLogging Info "Checking if loan period was set for another user previously"
loanPeriodSetOtherUser
ScriptLogging Info "——— END LoanShark Launcher ———"
exit 0
