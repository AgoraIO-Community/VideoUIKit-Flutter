## 1.3.10
- Upper bounds for lints

## 1.3.9
- Update to support newer lints

## 1.3.8
- Update types from agora_rtc_engine 6.3.0

## 1.3.7
- Fixes active speaker bug when user overrides with manual pin
- Updates permission_handler to v11.0.0

## 1.3.6

- Fixes error [[#151](https://github.com/AgoraIO-Community/VideoUIKit-Flutter/issues/151)
- Updating RTC to v6.2.2

## 1.3.5

- Allow for wider range of `http` packages

## 1.3.4

- Fixes error [#137](https://github.com/AgoraIO-Community/VideoUIKit-Flutter/issues/137)
- Setting RTC to v6.1.0 and RTM to v1.5.0

## 1.3.3

- BREAKING CHANGE: VideoSourceType for `onFirstLocalVideoFrame` callback

## 1.3.2

- Added callback for cloud recording destination URL
- Added loading state for cloud recording button
- Update to use new cloud recording schema

## 1.3.1

- BUG FIX: No longer shows cloud recording by default. Need to enable it with `cloudRecordingEnabled: true`

## 1.3.0

- Added Cloud Recording. Follow the [Guide](https://github.com/AgoraIO-Community/VideoUIKit-Flutter/wiki/Examples#cloud-recording)

## 1.2.1

- Fixes requestPort bug when joining from separate screen
- Fixes post call exception when going back to previous screen


## 1.2.0

- Added screen sharing for Android/iOS
- Added layout for one to one video calling
- Fixes issue [#122](https://github.com/AgoraIO-Community/VideoUIKit-Flutter/issues/122)


## 1.1.2

- Fixes issue [#115](https://github.com/AgoraIO-Community/VideoUIKit-Flutter/issues/115)
- Fixes view of remote user with a disabled video
- Fixes pinning a remote user causing white screen error

## 1.1.1

- Updated RTC to v6.1.0
- Updated RTM to v1.5.0

## 1.1.0

- Updated RTC to 4.x SDK 

## 1.0.4

- Updated README badges
- Added GitHub actions for publishing to pub.dev

## 1.0.3

- Updated permission_handler to [10.0.0](https://pub.dev/packages/permission_handler/changelog#1000). `compileSdkVersion` must be set to 33 as a minimum to handle the new notifications.
- Fixes issue [#98](https://github.com/AgoraIO-Community/Flutter-UIKit/issues/98). Added `onDisconnect` function inside the `AgoraVideoButtons` widget that can be used to define any navigation or function that occurs when the end call button is pressed. 
- Fixes issue [#96](https://github.com/AgoraIO-Community/Flutter-UIKit/issues/96). Added a broadcaster check before adding a user view to the grid layout. 

> When updating to version 1.0.3 make sure to update the android/app/build.gradle file and set the compileSdkVersion to 33.

## 1.0.2

- Fixes the issue with `enabledButtons`(issue [#86](https://github.com/AgoraIO-Community/Flutter-UIKit/issues/86))

## 1.0.1

- Add Error param to delegate methods to pass through the error
- Show correct versions of RTC and RTM
- Show RTM classes
- Update RTM to v1.1.1

## 1.0.0

  - Updated RTC to v5.2.0
  - JSON serialization for all the host controls
  - Cleaning the `session_controller`
  - Added RTM event handlers
  - RTM is enabled by default
  - Supports Flutter 3.0

## 1.0.0-beta.2

- Updated RTC to v5.2.0
- JSON serialization for all the host controls
- Cleaning the `session_controller`
- Added RTM event handlers
- RTM is enabled by default
- Supports Flutter 3.0

## 1.0.0-beta.1

  - Added Agora RTM SDK v1.1.0
  - Host Controls (Mute remote users audio and video)
  - Auto-permission for camera and mic (for all the broadcasters)
  - Fixes RTM IPV6 issue. 

## 0.0.4

  - Upgraded the agora_rtc_engine to v4.0.6
  - New method of initialization
  - Added all the event handlers
  - Fixed disabled video widget for grid view
  - Added video render mode

## 0.0.3

  - Upgraded the agora_rtc_engine to v4.0.5
  - Black Screen Fix
  - Remove unnecessary null checks
  - AreaCode bug fix
  - Added roadmaps to README.md

## 0.0.2

  - Update README

## 0.0.1
  
  Agora Flutter UIKit Release.
  Features: 
  * Automatically layout all video streams 
  * Builtin floating and grid layouts
  * Display the active speaker in the larger display while using the floating layout
  * Allowing you to pin any stream to the larger display while using the floating layout
  * Default buttons for disabling camera or microphone, switch cameras, end call
  * Add, remove or customize buttons
  * Auto hide buttons after a fixed period of time
  * Icon for signalling the local and remote user microphone and camera state
  * Display number of users in the channel
  * Automatically fetch token from a given token server
  * Subscribing to high or low-quality video streams

  
