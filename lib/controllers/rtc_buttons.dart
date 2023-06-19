import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Function to mute/unmute the microphone
Future<void> toggleMute({required SessionController sessionController}) async {
  var status = await Permission.microphone.status;
  if (sessionController.value.isLocalUserMuted && status.isDenied) {
    await Permission.microphone.request();
  }
  sessionController.value = sessionController.value
      .copyWith(isLocalUserMuted: !(sessionController.value.isLocalUserMuted));
  await sessionController.value.engine
      ?.muteLocalAudioStream(sessionController.value.isLocalUserMuted);
}

/// Function to toggle enable/disable the camera
Future<void> toggleCamera(
    {required SessionController sessionController}) async {
  var status = await Permission.camera.status;
  if (sessionController.value.isLocalVideoDisabled && status.isDenied) {
    await Permission.camera.request();
  }
  sessionController.value = sessionController.value.copyWith(
      isLocalVideoDisabled: !(sessionController.value.isLocalVideoDisabled));
  await sessionController.value.engine
      ?.muteLocalVideoStream(sessionController.value.isLocalVideoDisabled);
}

/// Function to switch between front and rear camera
Future<void> switchCamera(
    {required SessionController sessionController}) async {
  var status = await Permission.camera.status;
  if (status.isDenied) {
    await Permission.camera.request();
  }
  await sessionController.value.engine?.switchCamera();
}

/// Function to dispose the RTC and RTM engine.
Future<void> endCall({required SessionController sessionController}) async {
  if (sessionController.value.connectionData!.screenSharingEnabled &&
      sessionController.value.isScreenShared) {
    await sessionController.value.engine?.stopScreenCapture();
  }
  await sessionController.value.engine?.stopPreview();
  await sessionController.value.engine?.leaveChannel();
  if (sessionController.value.connectionData!.rtmEnabled) {
    await sessionController.value.agoraRtmChannel?.leave();
    await sessionController.value.agoraRtmClient?.logout();
  }
  await sessionController.value.engine?.release();
}

Timer? timer;

/// Function to auto hide the button class.
void toggleVisible({
  int autoHideButtonTime = 5,
  required AgoraSettings value,
}) async {
  if (!(value.visible)) {
    value = value.copyWith(visible: !(value.visible));
    timer = Timer(Duration(seconds: autoHideButtonTime), () {
      if (!(value.visible)) return;
      value = value.copyWith(visible: !(value.visible));
    });
  } else {
    timer?.cancel();
    value = value.copyWith(visible: !(value.visible));
  }
}

Future<void> shareScreen({required SessionController sessionController}) async {
  sessionController.value = sessionController.value.copyWith(
      turnOnScreenSharing: !(sessionController.value.turnOnScreenSharing));

  if (sessionController.value.turnOnScreenSharing) {
    await sessionController.value.engine?.startScreenCapture(
      const ScreenCaptureParameters2(
        captureAudio: false,
        audioParams: ScreenAudioParameters(
          sampleRate: 16000,
          channels: 2,
          captureSignalVolume: 100,
        ),
        captureVideo: true,
        videoParams: ScreenVideoParameters(
          dimensions: VideoDimensions(height: 1280, width: 720),
          frameRate: 15,
          bitrate: 600,
        ),
      ),
    );
    await _showRPSystemBroadcastPickerViewIfNeed();
  } else {
    await sessionController.value.engine?.stopScreenCapture();
  }

  // Update channel media options to publish camera or screen capture streams
  ChannelMediaOptions options = ChannelMediaOptions(
    publishCameraTrack: !(sessionController.value.isScreenShared),
    publishMicrophoneTrack: !(sessionController.value.isScreenShared),
    publishScreenTrack: sessionController.value.isScreenShared,
    publishScreenCaptureAudio: sessionController.value.isScreenShared,
    publishScreenCaptureVideo: sessionController.value.isScreenShared,
    clientRoleType: ClientRoleType.clientRoleBroadcaster,
  );

  await sessionController.value.engine?.updateChannelMediaOptions(options);
}

Future<void> _showRPSystemBroadcastPickerViewIfNeed() async {
  if (defaultTargetPlatform != TargetPlatform.iOS) {
    return;
  }

  final MethodChannel iosScreenShareChannel =
      const MethodChannel('example_screensharing_ios');
  await iosScreenShareChannel.invokeMethod('showRPSystemBroadcastPickerView');
}

/// Function to start and stop cloud recording
Future<void> toggleCloudRecording({required AgoraClient client}) async {
  if (client.sessionController.value.isCloudRecording ==
      RecordingState.recording) {
    //stop cloud recording
    client.sessionController.value = client.sessionController.value.copyWith(
      isCloudRecording: RecordingState.loading,
    );
    await client.sessionController
        .stopCloudRecording(connectionData: client.agoraConnectionData);
    client.sessionController.value = client.sessionController.value.copyWith(
      isCloudRecording: RecordingState.off,
    );
  } else if (client.sessionController.value.isCloudRecording ==
      RecordingState.off) {
    //start cloud recording
    client.sessionController.value = client.sessionController.value.copyWith(
      isCloudRecording: RecordingState.loading,
    );
    await client.sessionController
        .startCloudRecording(connectionData: client.agoraConnectionData);
    client.sessionController.value = client.sessionController.value.copyWith(
      isCloudRecording: RecordingState.recording,
    );
  } else {
    //do nothing
  }
}
