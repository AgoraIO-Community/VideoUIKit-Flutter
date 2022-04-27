import 'dart:convert';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/src/enums.dart';

void messageReceived({
  required String messageType,
  required Map<String, dynamic> message,
  required SessionController sessionController,
}) {
  switch (messageType) {
    case "UserData":
      message.forEach((key, val) {
        if (key == "text") {
          var json = jsonDecode(val);
          String rtmId = json['rtmId'];
          int rtcId = json['rtcId'];
          _addToUidUserMap(
            rtcId: rtcId,
            rtmId: rtmId,
            sessionController: sessionController,
          );
          _addToUserRtmMap(
            rtmId: rtmId,
            message: message,
            sessionController: sessionController,
          );
        }
      });
      break;
    case "MuteRequest":
      int? rtcId;
      bool? muted;
      message.forEach((key, val) {
        if (key == "text") {
          var json = jsonDecode(val);
          rtcId = json['rtcId'];
          muted = json['mute'];
        }
      });
      sessionController.value = sessionController.value.copyWith(
        displaySnackbar: true,
        muteRequest: muted! ? MicState.unmuted : MicState.muted,
        showCameraMessage: false,
        showMicMessage: true,
      );
      Future.delayed(Duration(seconds: 10), () {
        sessionController.value = sessionController.value.copyWith(
          displaySnackbar: false,
          showMicMessage: false,
        );
      });
      break;
    case "CameraRequest":
      int? rtcId;
      bool? disabled;
      message.forEach((key, val) {
        if (key == "text") {
          var json = jsonDecode(val);
          rtcId = json['rtcId'];
          disabled = json['mute'];
        }
      });
      sessionController.value = sessionController.value.copyWith(
        displaySnackbar: true,
        cameraRequest: disabled! ? CameraState.enabled : CameraState.disabled,
        showMicMessage: false,
        showCameraMessage: true,
      );
      Future.delayed(Duration(seconds: 10), () {
        sessionController.value = sessionController.value.copyWith(
          displaySnackbar: false,
          showCameraMessage: false,
        );
      });
      break;
    default:
  }
}

void _addToUidUserMap(
    {required int rtcId,
    required String rtmId,
    required SessionController sessionController}) {
  Map<int, String> tempMap = {};
  tempMap.addAll(sessionController.value.uidToUserIdMap ?? {});
  if (rtcId != 0) {
    tempMap.putIfAbsent(rtcId, () => rtmId);
  }
  sessionController.value =
      sessionController.value.copyWith(uidToUserIdMap: tempMap);
}

void _addToUserRtmMap({
  required String rtmId,
  required Map<String, dynamic> message,
  required SessionController sessionController,
}) {
  Map<String, Map<String, dynamic>> tempMap = {};
  tempMap.addAll(sessionController.value.userRtmMap ?? {});
  tempMap.putIfAbsent(rtmId, () => message);
  sessionController.value =
      sessionController.value.copyWith(userRtmMap: tempMap);
}

void removeFromUidToUserMap({
  required int rtcId,
  required SessionController sessionController,
}) {
  Map<int, String> tempMap = {};
  tempMap = sessionController.value.uidToUserIdMap!;
  for (int i = 0; i < tempMap.length; i++) {
    if (tempMap.keys.elementAt(i) == rtcId) {
      tempMap.remove(rtcId);
    }
  }
  sessionController.value =
      sessionController.value.copyWith(uidToUserIdMap: tempMap);
}

void removeFromUserRtmMap({
  required String rtmId,
  required SessionController sessionController,
}) {
  Map<String, Map<String, dynamic>> tempMap = {};
  tempMap = sessionController.value.userRtmMap!;
  for (int i = 0; i < tempMap.length; i++) {
    if (tempMap.keys.elementAt(i) == rtmId) {
      tempMap.remove(rtmId);
    }
  }
  sessionController.value =
      sessionController.value.copyWith(userRtmMap: tempMap);
}
