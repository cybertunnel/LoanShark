![Swift 5.0](https://img.shields.io/static/v1.svg?label=Swift&message=5.0&color=green&logo=swift)
![macOS 10.12](https://img.shields.io/static/v1.svg?label=macOS&message=10.12&color=green&logo=apple)
![macOS 10.13](https://img.shields.io/static/v1.svg?label=macOS&message=10.13&color=green&logo=apple)
![macOS 10.14](https://img.shields.io/static/v1.svg?label=macOS&message=10.14&color=green&logo=apple)
![macOS 10.15](https://img.shields.io/static/v1.svg?label=macOS&message=10.15&color=green&logo=apple)
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

![Notification - Not Configured](https://user-images.githubusercontent.com/23121750/66927992-b93c9e00-effe-11e9-9411-5b80fbfb957b.png)
![Notification - Active](https://user-images.githubusercontent.com/23121750/66927988-b93c9e00-effe-11e9-89b2-57e32b939bfa.png)
![Notification - Warning](https://user-images.githubusercontent.com/23121750/66927991-b93c9e00-effe-11e9-839f-a0064b6eb99c.png)
![Notification - Critical](https://user-images.githubusercontent.com/23121750/66927990-b93c9e00-effe-11e9-8b43-3f3162df5e85.png)

#### Jamf Pro Authentication
LoanShark uses Jamf Pro's API to provide a layer of security to authenticate users who are allowed to manage loaner devices.

![Authentication - Jamf Pro ](https://user-images.githubusercontent.com/23121750/66928470-6ca59280-efff-11e9-924b-f26d89f6c31c.png)
![Authentication - Jamf Pro - Filled](https://user-images.githubusercontent.com/23121750/66928472-6ca59280-efff-11e9-9e8b-73fc5f1aa4a8.png)

#### Shared Secret Authentication
LoanShark also allows the ability to use a passphrase, also known as a shared secret, to authenticate users who are allowed to manage loaner devices.
![Authentication - SharedSecret ](https://user-images.githubusercontent.com/23121750/66928694-d3c34700-efff-11e9-86ae-2b2d71a24b60.png)
![Authentication - SharedSecret - Filled ](https://user-images.githubusercontent.com/23121750/66928695-d3c34700-efff-11e9-9494-a25b642b5f32.png)


#### Life Cycle
LoanShark has a complete loaning lifecycle which includes custom duration, tech information, loanee information, extension requests, extensions, and expirations.

##### Configuration
After authenticating using Jamf Pro, or Shared Secret; the loaner is then able to be configured.
![Configuration Screen](https://user-images.githubusercontent.com/23121750/66929287-c35f9c00-f000-11e9-801c-276163055b74.png)
![Configuration Screen - Filled](https://user-images.githubusercontent.com/23121750/66929288-c35f9c00-f000-11e9-893f-cdd9adc52cc3.png)

##### Extension Request
When a loaner is about to expire, the user is provided a notification that asks if they want to extend the loaner. This will open the below window. Once submitted, it will open an email going to the person who deployed the loaner.
![Extension - Request](https://user-images.githubusercontent.com/23121750/66929735-8c3dba80-f001-11e9-812e-06fa07a7ff10.png)
![Extension - Request - Filled](https://user-images.githubusercontent.com/23121750/66929736-8c3dba80-f001-11e9-849f-6ea90d1c4079.png)

##### Extension - Authorized User
When an extension to a loaning period is recieved and approved to be performed; the user who is performing the extension can n avigate from the menu bar --> Admin --> Extend. The user will then be prompted to authenticate using Jamf Pro, or entering a Shared Secret. They will then see the below window.
![Extension](https://user-images.githubusercontent.com/23121750/66930296-606f0480-f002-11e9-9a73-aaaa1f76aebd.png)
![Extension - Filled](https://user-images.githubusercontent.com/23121750/66930298-606f0480-f002-11e9-9d8b-ad6d5890fad2.png)

##### Lockout & Logoff
When the loaning period expires, the user will then be locked out from being able to use the computer, and be forced to log off.
![Lockout](https://user-images.githubusercontent.com/23121750/66930550-c3f93200-f002-11e9-978d-ad027f04a223.png)

#### Automatic Email Extension Requests
LoanShark includes built in support to automatically open default mail client and send email to the tech who assigned the loaner

![Loaner Extension Request - Auto Email](https://user-images.githubusercontent.com/23121750/55245707-0f402480-521a-11e9-9b8b-b4639f4c16ca.png)

#### Agent Menu
LoanShark also has an agent menu that provides valuable information and actions in a quick manner.
![Agent Menu - Configured](https://user-images.githubusercontent.com/23121750/66930672-f30fa380-f002-11e9-9bb1-232fcbd5c0f2.png)
![Agent Menu - Not Configured](https://user-images.githubusercontent.com/23121750/66930673-f30fa380-f002-11e9-82ee-d2170403ba16.png)

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
