import 'dart:developer';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/rtm_message.dart';
import 'package:agora_uikit/src/enums.dart';

void askForUserMic({
  required int index,
  required bool isMicEnabled,
  required SessionController sessionController,
}) {
  String? peerId;
  String json = '''{
      "messageType": "MuteRequest",
      "rtcId": ${sessionController.value.users[index].uid},
      "mute": $isMicEnabled,
      "device": "0", 
      "isForceFul": "false"
    }''';

  Message message = Message(text: json);
  AgoraRtmMessage msg = AgoraRtmMessage.fromJson(message.toJson());
  sessionController.value.uidToUserIdMap!.forEach((key, val) {
    if (key == sessionController.value.users[index].uid) {
      peerId = val;
      if (sessionController.value.isLoggedIn) {
        sessionController.value.agoraRtmClient?.sendMessageToPeer(peerId!, msg);
      } else {
        log("User not logged in", level: Level.warning.value);
      }
    } else {
      log("Peer RTM ID not found", level: Level.warning.value);
    }
  });
}

void askForUserCamera({
  required int index,
  required bool isCameraEnabled,
  required SessionController sessionController,
}) {
  String? peerId;
  String json = '''{
      "messageType": "CameraRequest",
      "rtcId": ${sessionController.value.users[index].uid},
      "mute": $isCameraEnabled,
      "device": "1",
      "isForceFul": "false"
    }''';

  Message message = Message(text: json);
  AgoraRtmMessage msg = AgoraRtmMessage.fromJson(message.toJson());
  sessionController.value.uidToUserIdMap!.forEach((key, val) {
    if (key == sessionController.value.users[index].uid) {
      peerId = val;
      sessionController.value.agoraRtmClient?.sendMessageToPeer(peerId!, msg);
    } else {
      log("Peer RTM ID not found", level: Level.warning.value);
    }
  });
}
