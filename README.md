![Swift 4.0](https://img.shields.io/static/v1.svg?label=Swift&message=4.0&color=green&logo=swift)
![macOS 10.12](https://img.shields.io/static/v1.svg?label=macOS&message=10.12&color=green&logo=apple)
![macOS 10.13](https://img.shields.io/static/v1.svg?label=macOS&message=10.13&color=green&logo=apple)
![macOS 10.14](https://img.shields.io/static/v1.svg?label=macOS&message=10.14&color=green&logo=apple)
![macOS 10.15](https://img.shields.io/static/v1.svg?label=macOS&message=10.15&color=yellow&logo=apple)
![macOS Dark Mode](https://img.shields.io/static/v1.svg?label=Dark%20Mode&message=enabled&color=green&logo=apple)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Current LoanShark Version](https://img.shields.io/static/v1.svg?label=version&message=0.3&color=lightgrey)

# LoanShark![LoanShark](https://user-images.githubusercontent.com/23121750/55338309-71916300-546e-11e9-8517-b3d5cbd4ffbd.png)
LoanShark's goal is to provide a simple, yet effective management to your loaner fleet.
This utility allows you to:
- Lockout users after loaning period expires
- Provide custom loaning durations
- Enable users to remotely request loaning extensions

This currently supports Jamf Pro's interface for the Authentication piece.

### In Action

#### Notifications
LoanShark has built in support to send notifications to the end user, is displays a notification like the ones below.
![Notification - Active](https://user-images.githubusercontent.com/23121750/59713291-148b8a80-91dd-11e9-8881-1ee16ecd4112.png)
![Notification - Critical](https://user-images.githubusercontent.com/23121750/59713271-ffaef700-91dc-11e9-9d8b-b84ee3423c23.png)
![Notification - Not Set](https://user-images.githubusercontent.com/23121750/59713248-eefe8100-91dc-11e9-8322-56ad219d3cbd.png)
![Notification - Warning](https://user-images.githubusercontent.com/23121750/59713334-2ec56880-91dd-11e9-9488-c4847560bdf6.png)

#### Jamf Pro Authentication
LoanShark uses Jamf Pro's API to provide a layer of security to authenticate users who are allowed to manage loaner devices.

![Authentication - Configuration ](https://user-images.githubusercontent.com/23121750/55244990-9be9e300-5218-11e9-8836-997546709099.png)
![Authentication - Configuration - Entered](https://user-images.githubusercontent.com/23121750/55244995-9db3a680-5218-11e9-8eea-9327e47192e1.png)

#### Life Cycle
LoanShark has a complete loaning lifecycle which includes custom duration, tech information, loanee information, extension requests, extensions, and expirations.

![Configuration Screen - Entered](https://user-images.githubusercontent.com/23121750/55245618-dc962c00-5219-11e9-8a58-cb9baa23e166.png)
![Loaner Extension Request - Entered](https://user-images.githubusercontent.com/23121750/55245626-e029b300-5219-11e9-81b7-54b2aaa5e5aa.png)
![Loaner Extension Request](https://user-images.githubusercontent.com/23121750/55245638-e750c100-5219-11e9-8c0a-e15b84149bd3.png)
![Loaner Extension](https://user-images.githubusercontent.com/23121750/55245640-e881ee00-5219-11e9-8d04-f4229206fbe3.png)
![Loaner Expired](https://user-images.githubusercontent.com/23121750/55245647-e9b31b00-5219-11e9-88de-af6d9fee92e0.png)
![Lockout Window - Fullscreen](https://user-images.githubusercontent.com/23121750/55244620-e4ed6780-5217-11e9-8aba-d814b1b4f372.png)

#### Automatic Email Extension Requests
LoanShark includes built in support to automatically open default mail client and send email to the tech who assigned the loaner

![Loaner Extension Request - Auto Email](https://user-images.githubusercontent.com/23121750/55245707-0f402480-521a-11e9-9b8b-b4639f4c16ca.png)

## Quick Start
The best way to start is the [Kickstart Guide](https://github.com/cybertunnel/LoanShark/wiki).

## Release History
The release hisitory is available [here](https://github.com/cybertunnel/LoanShark/blob/master/CHANGELOG.md).

LoanShark was made possible thanks to the work for the [following individuals](https://github.com/cybertunnel/LoanShark/blob/master/THANKS.md).

## Getting Help
The best place to discuss LoanShark is to join the [#loanshark](https://macadmins.slack.com/messages/CHGFDDKST) channel on the [MacAdmins Slack](https://macadmins.herokuapp.com/)

## Contributing
I (cybertunnel) have been working on this project for over a year for the company I currently work for. I have spent these past few months making it more stable and esuring the availability for use for you guys.

Please feel free to fork and contribute.
