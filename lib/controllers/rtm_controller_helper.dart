import 'dart:convert';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtm_mute_request.dart';
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
          var userData = UserData.fromJson(jsonDecode(val.toString()));
          String rtmId = userData.rtmId;
          int rtcId = userData.rtcId;
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
      bool? muted;
      int? deviceId;
      message.forEach((key, val) {
        if (key == "text") {
          var muteRequest = MuteRequest.fromJson(jsonDecode(val.toString()));
          muted = muteRequest.mute;
          deviceId = muteRequest.device;
        }
      });
      if (deviceId == 0) {
        sessionController.value = sessionController.value.copyWith(
          displaySnackbar: true,
          cameraRequest: muted! ? CameraState.enabled : CameraState.disabled,
          showMicMessage: false,
          showCameraMessage: true,
        );
      } else if (deviceId == 1) {
        sessionController.value = sessionController.value.copyWith(
          displaySnackbar: true,
          muteRequest: muted! ? MicState.unmuted : MicState.muted,
          showCameraMessage: false,
          showMicMessage: true,
        );
      }

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
