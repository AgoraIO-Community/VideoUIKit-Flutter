import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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
  const String tag = "AgoraVideoUIKit";
  return RtcEngineEventHandler(onRejoinChannelSuccess: (connection, elapsed) {
    agoraEventHandlers.onRejoinChannelSuccess?.call(connection, elapsed);
  }, onLocalUserRegistered: (uid, userAccount) {
    agoraEventHandlers.onLocalUserRegistered?.call(uid, userAccount);
  }, onUserInfoUpdated: (uid, info) {
    agoraEventHandlers.onUserInfoUpdated?.call(uid, info);
  }, onClientRoleChanged: (connection, oldRole, newRole, newRoleOptions) {
    agoraEventHandlers.onClientRoleChanged
        ?.call(connection, oldRole, newRole, newRoleOptions);
  }, onClientRoleChangeFailed: (connection, reason, currentRole) {
    agoraEventHandlers.onClientRoleChangeFailed
        ?.call(connection, reason, currentRole);
  }, onConnectionStateChanged: (connection, state, reason) {
    agoraEventHandlers.onConnectionStateChanged
        ?.call(connection, state, reason);
  }, onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) {
    agoraEventHandlers.onNetworkQuality
        ?.call(connection, remoteUid, txQuality, rxQuality);
  }, onNetworkTypeChanged: (connection, type) {
    agoraEventHandlers.onNetworkTypeChanged?.call(connection, type);
  }, onUplinkNetworkInfoUpdated: (info) {
    agoraEventHandlers.onUplinkNetworkInfoUpdated?.call(info);
  }, onDownlinkNetworkInfoUpdated: (info) {
    agoraEventHandlers.onDownlinkNetworkInfoUpdated?.call(info);
  }, onConnectionLost: (connection) {
    agoraEventHandlers.onConnectionLost?.call(connection);
  }, onConnectionBanned: (connection) {
    agoraEventHandlers.onConnectionBanned?.call(connection);
  }, onConnectionInterrupted: (connection) {
    agoraEventHandlers.onConnectionInterrupted?.call(connection);
  }, onContentInspectResult: (result) {
    agoraEventHandlers.onContentInspectResult?.call(result);
  }, onProxyConnected: (channel, uid, proxyType, localProxyIp, elapsed) {
    agoraEventHandlers.onProxyConnected
        ?.call(channel, uid, proxyType, localProxyIp, elapsed);
  }, onRequestToken: (connection) {
    agoraEventHandlers.onRequestToken?.call(connection);
  }, onAudioVolumeIndication: (connection, speakers, speakerNumber, totalVolume) {
    agoraEventHandlers.onAudioVolumeIndication
        ?.call(connection, speakers, speakerNumber, totalVolume);
  }, onFirstLocalAudioFramePublished: (connection, elapsed) {
    agoraEventHandlers.onFirstLocalAudioFramePublished
        ?.call(connection, elapsed);
  }, onFirstLocalVideoFrame: (source, width, height, elapsed) {
    agoraEventHandlers.onFirstLocalVideoFrame
        ?.call(source, width, height, elapsed);
  }, onFirstLocalVideoFramePublished: (source, elapsed) {
    agoraEventHandlers.onFirstLocalVideoFramePublished?.call(source, elapsed);
  }, onFirstRemoteAudioDecoded: (connection, uid, elapsed) {
    agoraEventHandlers.onFirstRemoteAudioDecoded
        ?.call(connection, uid, elapsed);
  }, onFirstRemoteAudioFrame: (connection, userId, elapsed) {
    agoraEventHandlers.onFirstRemoteAudioFrame
        ?.call(connection, userId, elapsed);
  }, onFirstRemoteVideoFrame: (connection, remoteUid, width, height, elapsed) {
    agoraEventHandlers.onFirstRemoteVideoFrame
        ?.call(connection, remoteUid, width, height, elapsed);
  }, onFirstRemoteVideoDecoded: (connection, remoteUid, width, height, elapsed) {
    agoraEventHandlers.onFirstRemoteVideoDecoded
        ?.call(connection, remoteUid, width, height, elapsed);
  }, onUserMuteVideo: (connection, remoteUid, muted) {
    log("onUserMuteVideo- muted: $muted, uid: $remoteUid",
        name: tag, error: Level.info.value);
    if (remoteUid != sessionController.value.localUid) {
      sessionController.updateUserVideo(uid: remoteUid, videoDisabled: muted);
    }

    agoraEventHandlers.onUserMuteVideo?.call(connection, remoteUid, muted);
  }, onUserMuteAudio: (connection, remoteUid, muted) {
    log("onUserMuteAudio- muted: $muted, uid: $remoteUid",
        name: tag, error: Level.info.value);
    if (remoteUid != sessionController.value.localUid) {
      sessionController.updateUserAudio(uid: remoteUid, muted: muted);
    }

    agoraEventHandlers.onUserMuteAudio?.call(connection, remoteUid, muted);
  }, onVideoSizeChanged: (connection, sourceType, uid, width, height, rotation) {
    agoraEventHandlers.onVideoSizeChanged
        ?.call(connection, sourceType, uid, width, height, rotation);
  }, onLocalPublishFallbackToAudioOnly: (isFallbackOrRecover) {
    agoraEventHandlers.onLocalPublishFallbackToAudioOnly
        ?.call(isFallbackOrRecover);
  }, onRemoteSubscribeFallbackToAudioOnly: (uid, isFallbackOrRecover) {
    agoraEventHandlers.onRemoteSubscribeFallbackToAudioOnly
        ?.call(uid, isFallbackOrRecover);
  }, onAudioRoutingChanged: (routing) {
    agoraEventHandlers.onAudioRoutingChanged?.call(routing);
  }, onCameraFocusAreaChanged: (x, y, width, height) {
    agoraEventHandlers.onCameraExposureAreaChanged?.call(x, y, width, height);
  }, onCameraExposureAreaChanged: (x, y, width, height) {
    agoraEventHandlers.onCameraExposureAreaChanged?.call(x, y, width, height);
  }, onFacePositionChanged:
      (imageWidth, imageHeight, vecRectangle, vecDistance, numFaces) {
    agoraEventHandlers.onFacePositionChanged
        ?.call(imageWidth, imageHeight, vecRectangle, vecDistance, numFaces);
  }, onRtcStats: (connection, stats) {
    agoraEventHandlers.onRtcStats?.call(connection, stats);
  }, onLastmileQuality: (quality) {
    agoraEventHandlers.onLastmileQuality?.call(quality);
  }, onLastmileProbeResult: (result) {
    agoraEventHandlers.onLastmileProbeResult?.call(result);
  }, onLocalVideoStats: (source, stats) {
    agoraEventHandlers.onLocalVideoStats?.call(source, stats);
  }, onLocalAudioStats: (connection, stats) {
    agoraEventHandlers.onLocalAudioStats?.call(connection, stats);
  }, onRemoteVideoStats: (connection, stats) {
    agoraEventHandlers.onRemoteVideoStats?.call(connection, stats);
  }, onRemoteAudioStats: (connection, stats) {
    agoraEventHandlers.onRemoteAudioStats?.call(connection, stats);
  }, onAudioMixingFinished: () {
    agoraEventHandlers.onAudioMixingFinished?.call();
  }, onAudioMixingStateChanged: (state, reason) {
    agoraEventHandlers.onAudioMixingStateChanged?.call(state, reason);
  }, onAudioEffectFinished: (soundId) {
    agoraEventHandlers.onAudioEffectFinished?.call(soundId);
  }, onRtmpStreamingStateChanged: (url, state, errCode) {
    agoraEventHandlers.onRtmpStreamingStateChanged?.call(url, state, errCode);
  }, onRtmpStreamingEvent: (url, eventCode) {
    agoraEventHandlers.onRtmpStreamingEvent?.call(url, eventCode);
  }, onTranscodingUpdated: () {
    agoraEventHandlers.onTranscodingUpdated?.call();
  }, onStreamMessage: (connection, remoteUid, streamId, data, length, sentTs) {
    agoraEventHandlers.onStreamMessage
        ?.call(connection, remoteUid, streamId, data, length, sentTs);
  }, onStreamMessageError:
      (connection, remoteUid, streamId, code, missed, cached) {
    agoraEventHandlers.onStreamMessageError
        ?.call(connection, remoteUid, streamId, code, missed, cached);
  }, onChannelMediaRelayStateChanged: (state, code) {
    agoraEventHandlers.onChannelMediaRelayStateChanged?.call(state, code);
  }, onAudioPublishStateChanged:
      (channel, oldState, newState, elapseSinceLastState) {
    agoraEventHandlers.onAudioPublishStateChanged
        ?.call(channel, oldState, newState, elapseSinceLastState);
  }, onVideoPublishStateChanged:
      (source, channel, oldState, newState, elapseSinceLastState) {
    agoraEventHandlers.onVideoPublishStateChanged
        ?.call(source, channel, oldState, newState, elapseSinceLastState);
  }, onAudioSubscribeStateChanged:
      (channel, uid, oldState, newState, elapseSinceLastState) {
    agoraEventHandlers.onAudioSubscribeStateChanged
        ?.call(channel, uid, oldState, newState, elapseSinceLastState);
  }, onVideoSubscribeStateChanged:
      (channel, uid, oldState, newState, elapseSinceLastState) {
    agoraEventHandlers.onVideoSubscribeStateChanged
        ?.call(channel, uid, oldState, newState, elapseSinceLastState);
  }, onUploadLogResult: (connection, requestId, success, reason) {
    agoraEventHandlers.onUploadLogResult
        ?.call(connection, requestId, success, reason);
  }, onError: (err, msg) {
    final info = 'onError: $err';
    log(info, name: tag, level: Level.error.value);

    agoraEventHandlers.onError?.call(err, msg);
  }, onJoinChannelSuccess: (connection, elapsed) async {
    final info =
        'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
    log(info, name: tag, level: Level.info.value);
    sessionController.value =
        sessionController.value.copyWith(localUid: connection.localUid);

    await rtmMethods(
        agoraRtmChannelEventHandler: agoraRtmChannelEventHandler,
        sessionController: sessionController);

    sessionController.value = sessionController.value.copyWith(
      mainAgoraUser: AgoraUser(
        uid: connection.localUid!,
        remote: false,
        muted: sessionController.value.isLocalUserMuted,
        videoDisabled: sessionController.value.isLocalVideoDisabled,
        clientRoleType: sessionController.value.clientRoleType,
      ),
    );

    agoraEventHandlers.onJoinChannelSuccess?.call(connection, elapsed);
  }, onLeaveChannel: (connection, stats) {
    sessionController.clearUsers();

    agoraEventHandlers.onLeaveChannel?.call(connection, stats);
  }, onUserJoined: (connection, remoteUid, elapsed) {
    final info = 'userJoined: $remoteUid';
    log(info, name: tag, level: Level.info.value);
    sessionController.addUser(
      callUser: AgoraUser(
        uid: remoteUid,
      ),
    );

    agoraEventHandlers.onUserJoined?.call(connection, remoteUid, elapsed);
  }, onUserOffline: (connection, remoteUid, reason) {
    final info = 'userOffline: $remoteUid , reason: $reason';
    log(info, name: tag, level: Level.info.value);
    sessionController.checkForMaxUser(uid: remoteUid);
    sessionController.removeUser(uid: remoteUid);

    agoraEventHandlers.onUserOffline?.call(connection, remoteUid, reason);
  }, onTokenPrivilegeWillExpire: (connection, token) async {
    await getToken(
      tokenUrl: sessionController.value.connectionData!.tokenUrl,
      channelName: sessionController.value.connectionData!.channelName,
      uid: sessionController.value.connectionData!.uid,
      sessionController: sessionController,
    );
    await sessionController.value.engine?.renewToken(token);

    agoraEventHandlers.onTokenPrivilegeWillExpire?.call(connection, token);
  }, onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
    final String info =
        "Remote video state changed for $remoteUid, state: $state and reason: $reason";
    log(info, name: tag, level: Level.info.value);
    if (remoteUid != sessionController.value.localUid) {
      if (state == RemoteVideoState.remoteVideoStateStopped) {
        sessionController.updateUserVideo(uid: remoteUid, videoDisabled: true);
      } else if (state == RemoteVideoState.remoteVideoStateDecoding &&
          (state == RemoteVideoState.remoteVideoStateStarting ||
              reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonRemoteUnmuted)) {
        sessionController.updateUserVideo(uid: remoteUid, videoDisabled: false);
      }
    }

    agoraEventHandlers.onRemoteVideoStateChanged
        ?.call(connection, remoteUid, state, reason, elapsed);
  }, onRemoteAudioStateChanged: (connection, remoteUid, state, reason, elapsed) {
    final String info =
        "Remote audio state changed for $remoteUid, state: $state and reason: $reason";
    log(info, name: tag, level: Level.info.value);
    if (state == RemoteAudioState.remoteAudioStateStopped &&
        reason == RemoteAudioStateReason.remoteAudioReasonRemoteMuted &&
        remoteUid != sessionController.value.localUid) {
      sessionController.updateUserAudio(uid: remoteUid, muted: true);
    } else if (state == RemoteAudioState.remoteAudioStateDecoding &&
        reason == RemoteAudioStateReason.remoteAudioReasonRemoteUnmuted &&
        remoteUid != sessionController.value.localUid) {
      sessionController.updateUserAudio(uid: remoteUid, muted: false);
    }

    agoraEventHandlers.onRemoteAudioStateChanged
        ?.call(connection, remoteUid, state, reason, elapsed);
  }, onLocalAudioStateChanged: (connection, state, error) {
    final String info =
        "Local audio state changed state: $state and error: $error";
    log(info, name: tag, level: Level.info.value);

    agoraEventHandlers.onLocalAudioStateChanged?.call(connection, state, error);
  }, onLocalVideoStateChanged: (source, state, error) {
    final String info =
        "Local video state changed, source: $source, state: $state and error: $error";
    log(info, name: tag, level: Level.info.value);

    if (source == VideoSourceType.videoSourceScreenPrimary &&
        state == LocalVideoStreamState.localVideoStreamStateCapturing) {
      sessionController.value =
          sessionController.value.copyWith(isScreenShared: true);
    } else {
      sessionController.value =
          sessionController.value.copyWith(isScreenShared: false);
    }

    agoraEventHandlers.onLocalVideoStateChanged?.call(source, state, error);
  }, onActiveSpeaker: (connection, uid) {
    final String info = "Active speaker: $uid";
    log(info, name: tag, level: Level.info.value);
    if (sessionController.value.isActiveSpeakerDisabled == false &&
        sessionController.value.layoutType == Layout.floating) {
      final int index = sessionController.value.users
          .indexWhere((element) => element.uid == uid);
      sessionController.swapUser(index: index);
    } else {
      log("Active speaker is disabled", level: Level.info.value, name: tag);
    }

    agoraEventHandlers.onActiveSpeaker?.call(connection, uid);
  }, onAudioDeviceStateChanged: (deviceId, deviceType, deviceState) {
    agoraEventHandlers.onAudioDeviceStateChanged
        ?.call(deviceId, deviceType, deviceState);
  }, onAudioDeviceVolumeChanged: (deviceType, volume, muted) {
    agoraEventHandlers.onAudioDeviceVolumeChanged
        ?.call(deviceType, volume, muted);
  }, onAudioQuality: (connection, remoteUid, quality, delay, lost) {
    agoraEventHandlers.onAudioQuality
        ?.call(connection, remoteUid, quality, delay, lost);
  }, onCameraReady: () {
    agoraEventHandlers.onCameraReady?.call();
  }, onEncryptionError: (connection, errorType) {
    agoraEventHandlers.onEncryptionError?.call(connection, errorType);
  }, onExtensionError: (provider, extension, error, message) {
    agoraEventHandlers.onExtensionError
        ?.call(provider, extension, error, message);
  }, onExtensionEvent: (provider, extension, key, value) {
    agoraEventHandlers.onExtensionEvent?.call(provider, extension, key, value);
  }, onExtensionStarted: (provider, extension) {
    agoraEventHandlers.onExtensionStarted?.call(provider, extension);
  }, onExtensionStopped: (provider, extension) {
    agoraEventHandlers.onExtensionStopped?.call(provider, extension);
  }, onIntraRequestReceived: (connection) {
    agoraEventHandlers.onIntraRequestReceived?.call(connection);
  }, onPermissionError: (permissionType) {
    agoraEventHandlers.onPermissionError?.call(permissionType);
  }, onRemoteAudioTransportStats:
      (connection, remoteUid, delay, lost, rxKBitRate) {
    agoraEventHandlers.onRemoteAudioTransportStats
        ?.call(connection, remoteUid, delay, lost, rxKBitRate);
  }, onRemoteVideoTransportStats:
      (connection, remoteUid, delay, lost, rxKBitRate) {
    agoraEventHandlers.onRemoteVideoTransportStats
        ?.call(connection, remoteUid, delay, lost, rxKBitRate);
  }, onRhythmPlayerStateChanged: (state, errorCode) {
    agoraEventHandlers.onRhythmPlayerStateChanged?.call(state, errorCode);
  }, onSnapshotTaken: (connection, uid, filePath, width, height, errCode) {
    agoraEventHandlers.onSnapshotTaken
        ?.call(connection, uid, filePath, width, height, errCode);
  }, onUserAccountUpdated: (connection, remoteUid, userAccount) {
    agoraEventHandlers.onUserAccountUpdated
        ?.call(connection, remoteUid, userAccount);
  }, onUserEnableLocalVideo: (connection, remoteUid, enabled) {
    agoraEventHandlers.onUserEnableLocalVideo
        ?.call(connection, remoteUid, enabled);
  }, onUserEnableVideo: (connection, remoteUid, enabled) {
    agoraEventHandlers.onUserEnableLocalVideo
        ?.call(connection, remoteUid, enabled);
  }, onUserStateChanged: (connection, remoteUid, state) {
    agoraEventHandlers.onUserStateChanged?.call(connection, remoteUid, state);
  }, onVideoDeviceStateChanged: (deviceId, deviceType, deviceState) {
    agoraEventHandlers.onVideoDeviceStateChanged
        ?.call(deviceId, deviceType, deviceState);
  }, onVideoStopped: () {
    agoraEventHandlers.onVideoStopped?.call();
  }, onWlAccMessage: (connection, reason, action, wlAccMsg) {
    agoraEventHandlers.onWlAccMessage
        ?.call(connection, reason, action, wlAccMsg);
  }, onWlAccStats: (connection, currentStats, averageStats) {
    agoraEventHandlers.onWlAccStats
        ?.call(connection, currentStats, averageStats);
  });
}
