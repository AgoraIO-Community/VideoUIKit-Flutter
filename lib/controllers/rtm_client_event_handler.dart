import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/controllers/rtm_controller_helper.dart';
import 'package:agora_uikit/controllers/rtm_token_handler.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtm_client_event_handler.dart';
import 'package:agora_uikit/models/rtm_message.dart';
import 'package:agora_uikit/src/enums.dart';

Future<void> rtmClientEventHandler({
  required AgoraRtmClient agoraRtmClient,
  required AgoraRtmClientEventHandler agoraRtmClientEventHandler,
  required SessionController sessionController,
}) async {
  agoraRtmClient.onMessageReceived = (AgoraRtmMessage message, String peerId) {
    agoraRtmClientEventHandler.onMessageReceived?.call(message, peerId);
    Message msg = Message(text: message.text);
    String? messageType;

    message.toJson().forEach((key, val) {
      if (key == "text") {
        var json = jsonDecode(val.toString());
        messageType = json['messageType'];
      }
    });
    messageReceived(
      messageType: messageType!,
      message: msg.toJson(),
      sessionController: sessionController,
    );
  };

  agoraRtmClient.onConnectionStateChanged = (int state, int reason) {
    agoraRtmClientEventHandler.onConnectionStateChanged?.call(state, reason);

    log(
      'Connection state changed : ${state.toString()}, reason : ${reason.toString()}',
      level: Level.info.value,
      name: 'AgoraUIKit',
    );
    if (state == 5) {
      agoraRtmClient.logout();
    }
  };

  agoraRtmClient.onError = (error) {
    agoraRtmClientEventHandler.onError?.call(error);

    log(
      'Error Occurred while initializing the RTM client: ${error.hashCode}',
      level: Level.error.value,
      name: 'AgoraUIKit',
    );
  };

  agoraRtmClient.onTokenExpired = () {
    agoraRtmClientEventHandler.onTokenExpired?.call();

    getRtmToken(
      tokenUrl: sessionController.value.connectionData!.tokenUrl,
      sessionController: sessionController,
    );
  };

  agoraRtmClient.onLocalInvitationReceivedByPeer =
      (AgoraRtmLocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationReceivedByPeer
        ?.call(invitation);
  };

  agoraRtmClient.onLocalInvitationAccepted =
      (AgoraRtmLocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationAccepted?.call(invitation);
  };

  agoraRtmClient.onLocalInvitationRefused =
      (AgoraRtmLocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationRefused?.call(invitation);
  };

  agoraRtmClient.onLocalInvitationCanceled =
      (AgoraRtmLocalInvitation invitation) {
    agoraRtmClientEventHandler.onLocalInvitationCanceled?.call(invitation);
  };

  agoraRtmClient.onLocalInvitationFailure =
      (AgoraRtmLocalInvitation invitation, int errorCode) {
    agoraRtmClientEventHandler.onLocalInvitationFailure
        ?.call(invitation, errorCode);
  };

  agoraRtmClient.onRemoteInvitationReceivedByPeer =
      (AgoraRtmRemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationReceivedByPeer
        ?.call(invitation);
  };

  agoraRtmClient.onRemoteInvitationAccepted =
      (AgoraRtmRemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationAccepted?.call(invitation);
  };

  agoraRtmClient.onRemoteInvitationRefused =
      (AgoraRtmRemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationRefused?.call(invitation);
  };

  agoraRtmClient.onRemoteInvitationCanceled =
      (AgoraRtmRemoteInvitation invitation) {
    agoraRtmClientEventHandler.onRemoteInvitationCanceled?.call(invitation);
  };

  agoraRtmClient.onRemoteInvitationFailure =
      (AgoraRtmRemoteInvitation invitation, int errorCode) {
    agoraRtmClientEventHandler.onRemoteInvitationFailure
        ?.call(invitation, errorCode);
  };
}
