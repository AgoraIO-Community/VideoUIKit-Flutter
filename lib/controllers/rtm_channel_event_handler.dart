import 'dart:developer';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/controllers/rtm_controller.dart';
import 'package:agora_uikit/controllers/rtm_controller_helper.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtm_channel_event_handler.dart';
import 'package:agora_uikit/models/rtm_message.dart';
import 'package:agora_uikit/src/enums.dart';

Future<void> rtmChannelEventHandler({
  required AgoraRtmChannel channel,
  required AgoraRtmChannelEventHandler agoraRtmChannelEventHandler,
  required SessionController sessionController,
}) async {
  const String tag = "AgoraVideoUIKit";
  channel.onMessageReceived = (RtmMessage message, RtmChannelMember member) {
    agoraRtmChannelEventHandler.onMessageReceived?.call(
      message,
      member,
    );

    log(
      'Channel msg : ${message.text}, from : ${member.userId}',
      level: Level.info.value,
      name: tag,
    );
    Message msg = Message(text: message.text);
    messageReceived(
      messageType: "UserData",
      message: msg.toJson(),
      sessionController: sessionController,
    );
  };

  channel.onMemberJoined = (RtmChannelMember member) {
    agoraRtmChannelEventHandler.onMemberJoined?.call(member);

    log(
      'Member joined : ${member.userId}',
      level: Level.info.value,
      name: tag,
    );
    sendUserData(
      toChannel: false,
      username: sessionController.value.connectionData!.username!,
      peerRtmId: member.userId,
      sessionController: sessionController,
    );
  };

  channel.onMemberLeft = (RtmChannelMember member) {
    agoraRtmChannelEventHandler.onMemberLeft?.call(member);

    log(
      'Member left : ${member.userId}',
      level: Level.info.value,
      name: tag,
    );

    if (sessionController.value.userRtmMap!.containsKey(member.userId)) {
      removeFromUserRtmMap(
        rtmId: member.userId,
        sessionController: sessionController,
      );
    }

    if (sessionController.value.uidToUserIdMap!.containsValue(member.userId)) {
      for (var i = 0; i < sessionController.value.uidToUserIdMap!.length; i++) {
        int rtcId = sessionController.value.uidToUserIdMap!.keys.elementAt(i);
        removeFromUidToUserMap(
          rtcId: rtcId,
          sessionController: sessionController,
        );
      }
    }
  };

  channel.onMemberCountUpdated = (int count) {
    agoraRtmChannelEventHandler.onMemberCountUpdated?.call(count);

    log(
      'Member count updated : $count',
      level: Level.info.value,
      name: tag,
    );
  };

  channel.onAttributesUpdated = (List<RtmChannelAttribute> attributes) {
    agoraRtmChannelEventHandler.onAttributesUpdated?.call(attributes);

    log(
      'Channel attributes updated : $attributes',
      level: Level.info.value,
      name: tag,
    );
  };

  channel.onError = (dynamic error) {
    agoraRtmChannelEventHandler.onError?.call(error);

    log(
      'RTM Channel error: $error',
      level: Level.info.value,
      name: tag,
    );
  };
}
