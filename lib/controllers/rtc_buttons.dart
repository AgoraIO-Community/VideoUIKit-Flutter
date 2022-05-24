import 'dart:async';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:permission_handler/permission_handler.dart';

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
  await sessionController.value.engine?.leaveChannel();
  if (sessionController.value.connectionData!.rtmEnabled) {
    await sessionController.value.agoraRtmChannel?.leave();
    await sessionController.value.agoraRtmClient?.logout();
  }
  await sessionController.value.engine?.destroy();
}

Timer? timer;

/// Function to auto hide the button class.
void toggleVisible({
  int autoHideButtonTime = 5,
  required SessionController sessionController,
}) async {
  if (!(sessionController.value.visible)) {
    sessionController.value = sessionController.value
        .copyWith(visible: !(sessionController.value.visible));
    timer = Timer(Duration(seconds: autoHideButtonTime), () {
      if (!(sessionController.value.visible)) return;
      sessionController.value = sessionController.value
          .copyWith(visible: !(sessionController.value.visible));
    });
  } else {
    timer?.cancel();
    sessionController.value = sessionController.value
        .copyWith(visible: !(sessionController.value.visible));
  }
}
