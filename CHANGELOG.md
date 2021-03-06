# 1.0 Official Release
New Features:
- Fully 10.15 support
- New selections during loaner configuration
  - Days
  - Weeks
  - Months
- Gmail support while requesting an extension
- Loan status in UI menu bar
- User information populated from Jamf Pro

Changes:
- Removed old functions
- Restructured the code
- Cleaner and sleek UI
- Code converted to Swift 5

Bugfixes:
- Justification not included in email
- Shared secret bug where it wasn't being properly cased
- Authentication was being performed more than once
- UI freezes during authentication

# 0.3 Beta Release
- Generic authentication supported now
  - Uses a shared secret using SHA256 hash comparison
  - Does not require a MDM solution
- Command Line Interface with commands
- Argument parser to be used in with the Command Line Interface
- Fixed a logging bug
- Added back the previously delete preferences file
- Added detection of existing loan period for other users and kicks user out if they are not authorized to log into the loaner

## Management Tools
With the release of 0.3, there are now management tools available to help handle loaning periods and obtain key information to assist in monitoring loaners.

[Check These Tools Out](Tools/)

# 0.2.1 Jamf Cloud Authentication Hotfix
- Fixes an issue where authentication using Jamf API uses `:443` instead of `:8443`
  - Thanks @amit for testing using Jamf Cloud!

# 0.2 Alpha Release
- Authentication using Jamf Pro API
- Notifications to end users upon launch alerting them of time remaining
- Automatic Email extension requests
