
# Agora VideoUIKit for Flutter

<p align="center">
    <a href="https://pub.dev/packages/agora_uikit"><img src="https://img.shields.io/pub/likes/agora_uikit?logo=dart"/></a>
    <a href="https://pub.dev/packages/agora_uikit"><img src="https://img.shields.io/pub/popularity/agora_uikit?logo=dart"/></a>
    <a href="https://pub.dev/packages/agora_uikit"><img src="https://img.shields.io/pub/points/agora_uikit?logo=dart"/></a><br/>
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue?logo=flutter" alt="Platform" />
  <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/AgoraIO-Community/VideoUIKit-Flutter/pub-score.yml?branch=main
">
  <a href="https://pub.dev/packages/agora_uikit"><img src="https://img.shields.io/pub/v/agora_uikit"/></a>
  <img src="https://img.shields.io/github/license/agoraio-community/videouikit-flutter?color=red"
      alt="License: MIT" />
  <a href="https://www.agora.io/en/join-slack/"><img src="https://img.shields.io/badge/slack-@RTE%20Dev-blue.svg?logo=slack"></a>
</p>


Instantly integrate Agora video calling or video streaming into your Flutter application.  

> NOTE: The Flutter VideoUIKit( >version 1.1.0) uses the latest version of the Agora 4.x SDK. To know more about the changes and the new features in the 4.x SDK, kindly take a look at the [docs](https://docs.agora.io/en/video-calling/reference/release-notes?platform=flutter). 

## Getting started

<p align="center">
 <img src="https://i.ibb.co/1XhRmZ1/Group-4.png" alt="Agora Flutter VideoUIKit Layout Sample">
</p>


### Roadmap

- [ ] Add Usernames
- [x] More Event Callbacks
- [x] Add RTM SDK
- [x] Screen Sharing (Currently in Beta)
- [x] Layout for One to One Video Call
- [ ] Layout for Voice Calls
- [ ] Re-orderable list view (Floating Layout)
- [ ] Cloud recording
- [ ] Promoting an audience member to a broadcaster role.
- [x] Muting/Unmuting a remote member
- [x] Flutter Web Support as a pre-release
- [ ] Flutter Desktop Support as a pre-release

### Requirements

-  [An Agora developer account](https://www.agora.io/en/blog/how-to-get-started-with-agora)
- An Android or iOS Device
- A Flutter Project
  
### Installation

In your Flutter application, add the `agora_uikit` as a dependency inside your `pubspec.yaml` file.

In your Android level `build.gradle` add this at the end of the repositories:  

```css
allprojects {
	repositories {
		...
		maven { url 'https://jitpack.io' }
	}
}
```

### Device Permission

Agora Video SDK requires `camera` and `microphone` permission to start video call.

#### Android

Open the `AndroidManifest.xml` file and add the required device permissions to the file.

```xml
<manifest>
...
<uses-permission  android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission  android:name="android.permission.INTERNET"  />
<uses-permission  android:name="android.permission.RECORD_AUDIO"  />
<uses-permission  android:name="android.permission.CAMERA"  />
<uses-permission  android:name="android.permission.MODIFY_AUDIO_SETTINGS"  />
<uses-permission  android:name="android.permission.ACCESS_NETWORK_STATE"  />
<!-- The Agora SDK requires Bluetooth permissions in case users are using Bluetooth devices.-->
<uses-permission  android:name="android.permission.BLUETOOTH"  />
...
</manifest>
```

#### iOS

Open `info.plist` and add:

-  `Privacy - Microphone Usage Description`, and add a note in the Value column.
-  `Privacy - Camera Usage Description`, and add a note in the Value column.

Your application can still run the voice call when it is switched to the background if the background mode is enabled. Select the app target in Xcode, click the Capabilities tab, enable Background Modes, and check Audio, AirPlay, and Picture in Picture.

## Usage

```dart
// Instantiate the client
final AgoraClient client = AgoraClient(
  agoraConnectionData: AgoraConnectionData(
    appId: "<--Add Your App Id Here-->",
    channelName: "test",
  ),
);

// Initialize the Agora Engine
@override
void initState() {
  super.initState();
  initAgora();
}

void initAgora() async {
  await client.initialize();
}

// Build your layout
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client), 
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    ),
  );
}

```


## VideoUIKits

The plan is to grow this library and have similar offerings across all supported platforms. There are already similar libraries for [Android](https://github.com/AgoraIO-Community/VideoUIKit-Android/), [iOS](https://github.com/AgoraIO-Community/VideoUIKit-iOS/), [React Native](https://github.com/AgoraIO-Community/ReactNative-UIKit), and [Web React](https://github.com/AgoraIO-Community/VideoUIKit-Web-React), so be sure to check them out.
