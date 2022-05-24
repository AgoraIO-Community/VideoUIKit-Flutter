import 'dart:developer';
import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_uikit/controllers/rtc_token_handler.dart';
import 'package:agora_uikit/controllers/rtm_controller.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_rtc_event_handlers.dart';
import 'package:agora_uikit/models/agora_rtm_channel_event_handler.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/src/enums.dart';

Future<RtcEngineEventHandler> rtcEngineEventHandler(
  AgoraRtcEventHandlers agoraEventHandlers,
  AgoraRtmChannelEventHandler agoraRtmChannelEventHandler,
  SessionController sessionController,
) async {
  return RtcEngineEventHandler(
    warning: (warning) {
      agoraEventHandlers.warning?.call(warning);
    },
    apiCallExecuted: (error, api, result) {
      agoraEventHandlers.apiCallExecuted?.call(error, api, result);
    },
    rejoinChannelSuccess: (channel, uid, elapsed) {
      agoraEventHandlers.rejoinChannelSuccess?.call(channel, uid, elapsed);
    },
    localUserRegistered: (uid, userAccount) {
      agoraEventHandlers.localUserRegistered?.call(uid, userAccount);
    },
    userInfoUpdated: (uid, userInfo) {
      agoraEventHandlers.userInfoUpdated?.call(uid, userInfo);
    },
    clientRoleChanged: (oldRole, newRole) {
      agoraEventHandlers.clientRoleChanged?.call(oldRole, newRole);
    },
    connectionStateChanged: (state, reason) {
      agoraEventHandlers.connectionStateChanged?.call(state, reason);
    },
    networkTypeChanged: (type) {
      agoraEventHandlers.networkTypeChanged?.call(type);
    },
    connectionLost: () {
      agoraEventHandlers.connectionLost?.call();
    },
    requestToken: () {
      agoraEventHandlers.requestToken?.call();
    },
    audioVolumeIndication: (speakers, totalVolume) {
      agoraEventHandlers.audioVolumeIndication?.call(speakers, totalVolume);
    },
    firstLocalAudioFrame: (elapsed) {
      agoraEventHandlers.firstLocalAudioFrame?.call(elapsed);
    },
    firstLocalVideoFrame: (width, height, elapsed) {
      agoraEventHandlers.firstLocalVideoFrame?.call(width, height, elapsed);
    },
    userMuteVideo: (uid, muted) {
      agoraEventHandlers.userMuteVideo?.call(uid, muted);
    },
    videoSizeChanged: (uid, width, height, rotation) {
      agoraEventHandlers.videoSizeChanged?.call(uid, width, height, rotation);
    },
    localPublishFallbackToAudioOnly: (isFallbackOrRecover) {
      agoraEventHandlers.localPublishFallbackToAudioOnly
          ?.call(isFallbackOrRecover);
    },
    remoteSubscribeFallbackToAudioOnly: (uid, isFallbackOrRecover) {
      agoraEventHandlers.remoteSubscribeFallbackToAudioOnly
          ?.call(uid, isFallbackOrRecover);
    },
    audioRouteChanged: (routing) {
      agoraEventHandlers.audioRouteChanged?.call(routing);
    },
    cameraFocusAreaChanged: (rect) {
      agoraEventHandlers.cameraFocusAreaChanged?.call(rect);
    },
    cameraExposureAreaChanged: (rect) {
      agoraEventHandlers.cameraExposureAreaChanged?.call(rect);
    },
    facePositionChanged: (imageWidth, imageHeight, faces) {
      agoraEventHandlers.facePositionChanged
          ?.call(imageWidth, imageHeight, faces);
    },
    rtcStats: (stats) {
      agoraEventHandlers.rtcStats?.call(stats);
    },
    lastmileQuality: (quality) {
      agoraEventHandlers.lastmileQuality?.call(quality);
    },
    networkQuality: (uid, txQuality, rxQuality) {
      agoraEventHandlers.networkQuality?.call(uid, txQuality, rxQuality);
    },
    lastmileProbeResult: (result) {
      agoraEventHandlers.lastmileProbeResult?.call(result);
    },
    localVideoStats: (stats) {
      agoraEventHandlers.localVideoStats?.call(stats);
    },
    localAudioStats: (stats) {
      agoraEventHandlers.localAudioStats?.call(stats);
    },
    remoteVideoStats: (stats) {
      agoraEventHandlers.remoteVideoStats?.call(stats);
    },
    remoteAudioStats: (stats) {
      agoraEventHandlers.remoteAudioStats?.call(stats);
    },
    audioMixingFinished: () {
      agoraEventHandlers.audioMixingFinished?.call();
    },
    audioMixingStateChanged: (state, reason) {
      agoraEventHandlers.audioMixingStateChanged?.call(state, reason);
    },
    audioEffectFinished: (soundId) {
      agoraEventHandlers.audioEffectFinished?.call(soundId);
    },
    rtmpStreamingStateChanged: (url, state, errCode) {
      agoraEventHandlers.rtmpStreamingStateChanged?.call(url, state, errCode);
    },
    transcodingUpdated: () {
      agoraEventHandlers.transcodingUpdated?.call();
    },
    streamInjectedStatus: (url, uid, status) {
      agoraEventHandlers.streamInjectedStatus?.call(url, uid, status);
    },
    streamMessage: (int uid, int streamId, Uint8List data) {
      agoraEventHandlers.streamMessage?.call(uid, streamId, data);
    },
    streamMessageError: (uid, streamId, error, missed, cached) {
      agoraEventHandlers.streamMessageError
          ?.call(uid, streamId, error, missed, cached);
    },
    mediaEngineLoadSuccess: () {
      agoraEventHandlers.mediaEngineLoadSuccess?.call();
    },
    mediaEngineStartCallSuccess: () {
      agoraEventHandlers.mediaEngineStartCallSuccess?.call();
    },
    channelMediaRelayStateChanged: (state, code) {
      agoraEventHandlers.channelMediaRelayStateChanged?.call(state, code);
    },
    channelMediaRelayEvent: (code) {
      agoraEventHandlers.channelMediaRelayEvent?.call(code);
    },
    metadataReceived: (metadata) {
      agoraEventHandlers.metadataReceived?.call(metadata);
    },
    firstLocalVideoFramePublished: (elapsed) {
      agoraEventHandlers.firstLocalVideoFramePublished?.call(elapsed);
    },
    firstLocalAudioFramePublished: (elapsed) {
      agoraEventHandlers.firstLocalAudioFramePublished?.call(elapsed);
    },
    audioPublishStateChanged:
        (channel, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.audioPublishStateChanged
          ?.call(channel, oldState, newState, elapseSinceLastState);
    },
    videoPublishStateChanged:
        (channel, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.videoPublishStateChanged
          ?.call(channel, oldState, newState, elapseSinceLastState);
    },
    audioSubscribeStateChanged:
        (channel, uid, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.audioSubscribeStateChanged
          ?.call(channel, uid, oldState, newState, elapseSinceLastState);
    },
    videoSubscribeStateChanged:
        (channel, uid, oldState, newState, elapseSinceLastState) {
      agoraEventHandlers.videoSubscribeStateChanged
          ?.call(channel, uid, oldState, newState, elapseSinceLastState);
    },
    rtmpStreamingEvent: (url, eventCode) {
      agoraEventHandlers.rtmpStreamingEvent?.call(url, eventCode);
    },
    userSuperResolutionEnabled: (uid, enabled, reason) {
      agoraEventHandlers.userSuperResolutionEnabled?.call(uid, enabled, reason);
    },
    uploadLogResult: (requestId, success, reason) {
      agoraEventHandlers.uploadLogResult?.call(requestId, success, reason);
    },
    error: (code) {
      final info = 'onError: $code';
      log(info, level: Level.error.value);

      agoraEventHandlers.onError?.call(code);
    },
    joinChannelSuccess: (channel, uid, elapsed) {
      final info = 'onJoinChannel: $channel, uid: $uid';
      log(info, name: "AgoraUIKit", level: Level.info.value);
      sessionController.value = sessionController.value.copyWith(localUid: uid);
      sessionController.value = sessionController.value.copyWith(
        mainAgoraUser: AgoraUser(
          uid: uid,
          remote: false,
          muted: sessionController.value.isLocalUserMuted,
          videoDisabled: sessionController.value.isLocalVideoDisabled,
          clientRole: sessionController.value.clientRole,
        ),
      );
      if (sessionController.value.connectionData!.rtmEnabled) {
        rtmMethods(
          agoraRtmChannelEventHandler,
          sessionController,
        );
      }
      agoraEventHandlers.joinChannelSuccess?.call(channel, uid, elapsed);
    },
    leaveChannel: (stats) {
      sessionController.clearUsers();
      agoraEventHandlers.leaveChannel?.call(stats);
    },
    userJoined: (uid, elapsed) {
      final info = 'userJoined: $uid';
      log(info, level: Level.info.value);
      sessionController.addUser(
        callUser: AgoraUser(
          uid: uid,
        ),
      );

      agoraEventHandlers.userJoined?.call(uid, elapsed);
    },
    userOffline: (uid, reason) {
      final info = 'userOffline: $uid , reason: $reason';
      log(info, level: Level.info.value);
      sessionController.checkForMaxUser(uid: uid);
      sessionController.removeUser(uid: uid);

      agoraEventHandlers.userOffline?.call(uid, reason);
    },
    tokenPrivilegeWillExpire: (token) async {
      await getToken(
        tokenUrl: sessionController.value.connectionData!.tokenUrl,
        channelName: sessionController.value.connectionData!.channelName,
        uid: sessionController.value.connectionData!.uid,
        sessionController: sessionController,
      );
      await sessionController.value.engine?.renewToken(token);

      agoraEventHandlers.tokenPrivilegeWillExpire?.call(token);
    },
    remoteVideoStateChanged: (uid, state, reason, elapsed) {
      final String info =
          "Remote video state changed for $uid, state: $state and reason: $reason";
      log(info, level: Level.info.value);
      if (uid != sessionController.value.localUid) {
        if (state == VideoRemoteState.Stopped) {
          sessionController.updateUserVideo(uid: uid, videoDisabled: true);
        } else if (state == VideoRemoteState.Decoding &&
            reason == VideoRemoteStateReason.RemoteUnmuted) {
          sessionController.updateUserVideo(uid: uid, videoDisabled: false);
        }
      }

      agoraEventHandlers.remoteVideoStateChanged
          ?.call(uid, state, reason, elapsed);
    },
    remoteAudioStateChanged: (uid, state, reason, elapsed) {
      final String info =
          "Remote audio state changed for $uid, state: $state and reason: $reason";
      log(info, level: Level.info.value);
      if (state == AudioRemoteState.Stopped &&
          reason == AudioRemoteStateReason.RemoteMuted &&
          uid != sessionController.value.localUid) {
        sessionController.updateUserAudio(uid: uid, muted: true);
      } else if (state == AudioRemoteState.Decoding &&
          reason == AudioRemoteStateReason.RemoteUnmuted &&
          uid != sessionController.value.localUid) {
        sessionController.updateUserAudio(uid: uid, muted: false);
      }

      agoraEventHandlers.remoteAudioStateChanged
          ?.call(uid, state, reason, elapsed);
    },
    localAudioStateChanged: (state, error) {
      final String info =
          "Local audio state changed state: $state and error: $error";
      log(info, level: Level.info.value);
      agoraEventHandlers.localAudioStateChanged?.call(state, error);
    },
    localVideoStateChanged: (localVideoState, error) {
      final String info =
          "Local video state changed state: $localVideoState and error: $error";
      log(info, level: Level.info.value);

      agoraEventHandlers.localVideoStateChanged?.call(localVideoState, error);
    },
    activeSpeaker: (uid) {
      final String info = "Active speaker: $uid";
      log(info, level: Level.info.value);
      if (sessionController.value.isActiveSpeakerDisabled == false &&
          sessionController.value.layoutType == Layout.floating) {
        final int index = sessionController.value.users
            .indexWhere((element) => element.uid == uid);
        sessionController.swapUser(index: index);
      } else {
        log("Active speaker is disabled", level: Level.info.value);
      }

      agoraEventHandlers.activeSpeaker?.call(uid);
    },
  );
}
