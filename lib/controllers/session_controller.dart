import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_event_handlers.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SessionController extends ValueNotifier<AgoraSettings> {
  SessionController()
      : super(
          AgoraSettings(
            engine: null,
            users: [],
            mainAgoraUser: AgoraUser(
              uid: 0,
              remote: true,
              muted: false,
              videoDisabled: false,
              clientRole: ClientRole.Broadcaster,
            ),
            isLocalUserMuted: false,
            isLocalVideoDisabled: false,
            visible: true,
            clientRole: ClientRole.Broadcaster,
            localUid: 0,
            generatedToken: null,
            layoutType: Layout.grid,
          ),
        );

  Future<void> initializeEngine(
      {required AgoraConnectionData agoraConnectionData}) async {
    value = value.copyWith(
      engine: await RtcEngine.createWithContext(
        RtcEngineContext(
          agoraConnectionData.appId,
          areaCode: agoraConnectionData.areaCode,
        ),
      ),
      connectionData: agoraConnectionData,
    );
  }

  void createEvents(AgoraEventHandlers agoraEventHandlers) async {
    value.engine?.setEventHandler(
      RtcEngineEventHandler(
        warning: (warning) {
          if (agoraEventHandlers.warning != null) {
            agoraEventHandlers.warning!(warning);
          }
        },
        apiCallExecuted: (error, api, result) {
          if (agoraEventHandlers.apiCallExecuted != null) {
            agoraEventHandlers.apiCallExecuted!(error, api, result);
          }
        },
        rejoinChannelSuccess: (channel, uid, elapsed) {
          if (agoraEventHandlers.rejoinChannelSuccess != null) {
            agoraEventHandlers.rejoinChannelSuccess!(channel, uid, elapsed);
          }
        },
        localUserRegistered: (uid, userAccount) {
          if (agoraEventHandlers.localUserRegistered != null) {
            agoraEventHandlers.localUserRegistered!(uid, userAccount);
          }
        },
        userInfoUpdated: (uid, userInfo) {
          if (agoraEventHandlers.userInfoUpdated != null) {
            agoraEventHandlers.userInfoUpdated!(uid, userInfo);
          }
        },
        clientRoleChanged: (oldRole, newRole) {
          if (agoraEventHandlers.clientRoleChanged != null) {
            agoraEventHandlers.clientRoleChanged!(oldRole, newRole);
          }
        },
        connectionStateChanged: (state, reason) {
          if (agoraEventHandlers.connectionStateChanged != null) {
            agoraEventHandlers.connectionStateChanged!(state, reason);
          }
        },
        networkTypeChanged: (type) {
          if (agoraEventHandlers.networkTypeChanged != null) {
            agoraEventHandlers.networkTypeChanged!(type);
          }
        },
        connectionLost: () {
          if (agoraEventHandlers.connectionLost != null) {
            agoraEventHandlers.connectionLost!();
          }
        },
        requestToken: () {
          if (agoraEventHandlers.requestToken != null) {
            agoraEventHandlers.requestToken!();
          }
        },
        audioVolumeIndication: (speakers, totalVolume) {
          if (agoraEventHandlers.audioVolumeIndication != null) {
            agoraEventHandlers.audioVolumeIndication!(speakers, totalVolume);
          }
        },
        firstLocalAudioFrame: (elapsed) {
          if (agoraEventHandlers.firstLocalAudioFrame != null) {
            agoraEventHandlers.firstLocalAudioFrame!(elapsed);
          }
        },
        firstLocalVideoFrame: (width, height, elapsed) {
          if (agoraEventHandlers.firstLocalVideoFrame != null) {
            agoraEventHandlers.firstLocalVideoFrame!(width, height, elapsed);
          }
        },
        userMuteVideo: (uid, muted) {
          if (agoraEventHandlers.userMuteVideo != null) {
            agoraEventHandlers.userMuteVideo!(uid, muted);
          }
        },
        videoSizeChanged: (uid, width, height, rotation) {
          if (agoraEventHandlers.videoSizeChanged != null) {
            agoraEventHandlers.videoSizeChanged!(uid, width, height, rotation);
          }
        },
        localPublishFallbackToAudioOnly: (isFallbackOrRecover) {
          if (agoraEventHandlers.localPublishFallbackToAudioOnly != null) {
            agoraEventHandlers
                .localPublishFallbackToAudioOnly!(isFallbackOrRecover);
          }
        },
        remoteSubscribeFallbackToAudioOnly: (uid, isFallbackOrRecover) {
          if (agoraEventHandlers.remoteSubscribeFallbackToAudioOnly != null) {
            agoraEventHandlers.remoteSubscribeFallbackToAudioOnly!(
                uid, isFallbackOrRecover);
          }
        },
        audioRouteChanged: (routing) {
          if (agoraEventHandlers.audioRouteChanged != null) {
            agoraEventHandlers.audioRouteChanged!(routing);
          }
        },
        cameraFocusAreaChanged: (rect) {
          if (agoraEventHandlers.cameraFocusAreaChanged != null) {
            agoraEventHandlers.cameraFocusAreaChanged!(rect);
          }
        },
        cameraExposureAreaChanged: (rect) {
          if (agoraEventHandlers.cameraExposureAreaChanged != null) {
            agoraEventHandlers.cameraExposureAreaChanged!(rect);
          }
        },
        facePositionChanged: (imageWidth, imageHeight, faces) {
          if (agoraEventHandlers.facePositionChanged != null) {
            agoraEventHandlers.facePositionChanged!(
                imageWidth, imageHeight, faces);
          }
        },
        rtcStats: (stats) {
          if (agoraEventHandlers.rtcStats != null) {
            agoraEventHandlers.rtcStats!(stats);
          }
        },
        lastmileQuality: (quality) {
          if (agoraEventHandlers.lastmileQuality != null) {
            agoraEventHandlers.lastmileQuality!(quality);
          }
        },
        networkQuality: (uid, txQuality, rxQuality) {
          if (agoraEventHandlers.networkQuality != null) {
            agoraEventHandlers.networkQuality!(uid, txQuality, rxQuality);
          }
        },
        lastmileProbeResult: (result) {
          if (agoraEventHandlers.lastmileProbeResult != null) {
            agoraEventHandlers.lastmileProbeResult!(result);
          }
        },
        localVideoStats: (stats) {
          if (agoraEventHandlers.localVideoStats != null) {
            agoraEventHandlers.localVideoStats!(stats);
          }
        },
        localAudioStats: (stats) {
          if (agoraEventHandlers.localAudioStats != null) {
            agoraEventHandlers.localAudioStats!(stats);
          }
        },
        remoteVideoStats: (stats) {
          if (agoraEventHandlers.remoteVideoStats != null) {
            agoraEventHandlers.remoteVideoStats!(stats);
          }
        },
        remoteAudioStats: (stats) {
          if (agoraEventHandlers.remoteAudioStats != null) {
            agoraEventHandlers.remoteAudioStats!(stats);
          }
        },
        audioMixingFinished: () {
          if (agoraEventHandlers.audioMixingFinished != null) {
            agoraEventHandlers.audioMixingFinished!();
          }
        },
        audioMixingStateChanged: (state, reason) {
          if (agoraEventHandlers.audioMixingStateChanged != null) {
            agoraEventHandlers.audioMixingStateChanged!(state, reason);
          }
        },
        audioEffectFinished: (soundId) {
          if (agoraEventHandlers.audioEffectFinished != null) {
            agoraEventHandlers.audioEffectFinished!(soundId);
          }
        },
        rtmpStreamingStateChanged: (url, state, errCode) {
          if (agoraEventHandlers.rtmpStreamingStateChanged != null) {
            agoraEventHandlers.rtmpStreamingStateChanged!(url, state, errCode);
          }
        },
        transcodingUpdated: () {
          if (agoraEventHandlers.transcodingUpdated != null) {
            agoraEventHandlers.transcodingUpdated!();
          }
        },
        streamInjectedStatus: (url, uid, status) {
          if (agoraEventHandlers.streamInjectedStatus != null) {
            agoraEventHandlers.streamInjectedStatus!(url, uid, status);
          }
        },
        streamMessage: (uid, streamId, data) {
          if (agoraEventHandlers.streamMessage != null) {
            agoraEventHandlers.streamMessage!(uid, streamId, data);
          }
        },
        streamMessageError: (uid, streamId, error, missed, cached) {
          if (agoraEventHandlers.streamMessageError != null) {
            agoraEventHandlers.streamMessageError!(
                uid, streamId, error, missed, cached);
          }
        },
        mediaEngineLoadSuccess: () {
          if (agoraEventHandlers.mediaEngineLoadSuccess != null) {
            agoraEventHandlers.mediaEngineLoadSuccess!();
          }
        },
        mediaEngineStartCallSuccess: () {
          if (agoraEventHandlers.mediaEngineStartCallSuccess != null) {
            agoraEventHandlers.mediaEngineStartCallSuccess!();
          }
        },
        channelMediaRelayStateChanged: (state, code) {
          if (agoraEventHandlers.channelMediaRelayStateChanged != null) {
            agoraEventHandlers.channelMediaRelayStateChanged!(state, code);
          }
        },
        channelMediaRelayEvent: (code) {
          if (agoraEventHandlers.channelMediaRelayEvent != null) {
            agoraEventHandlers.channelMediaRelayEvent!(code);
          }
        },
        metadataReceived: (buffer, uid, timeStampMs) {
          if (agoraEventHandlers.metadataReceived != null) {
            agoraEventHandlers.metadataReceived!(buffer, uid, timeStampMs);
          }
        },
        firstLocalVideoFramePublished: (elapsed) {
          if (agoraEventHandlers.firstLocalVideoFramePublished != null) {
            agoraEventHandlers.firstLocalVideoFramePublished!(elapsed);
          }
        },
        firstLocalAudioFramePublished: (elapsed) {
          if (agoraEventHandlers.firstLocalAudioFramePublished != null) {
            agoraEventHandlers.firstLocalAudioFramePublished!(elapsed);
          }
        },
        audioPublishStateChanged:
            (channel, oldState, newState, elapseSinceLastState) {
          if (agoraEventHandlers.audioPublishStateChanged != null) {
            agoraEventHandlers.audioPublishStateChanged!(
                channel, oldState, newState, elapseSinceLastState);
          }
        },
        videoPublishStateChanged:
            (channel, oldState, newState, elapseSinceLastState) {
          if (agoraEventHandlers.videoPublishStateChanged != null) {
            agoraEventHandlers.videoPublishStateChanged!(
                channel, oldState, newState, elapseSinceLastState);
          }
        },
        audioSubscribeStateChanged:
            (channel, uid, oldState, newState, elapseSinceLastState) {
          if (agoraEventHandlers.audioSubscribeStateChanged != null) {
            agoraEventHandlers.audioSubscribeStateChanged!(
                channel, uid, oldState, newState, elapseSinceLastState);
          }
        },
        videoSubscribeStateChanged:
            (channel, uid, oldState, newState, elapseSinceLastState) {
          if (agoraEventHandlers.videoSubscribeStateChanged != null) {
            agoraEventHandlers.videoSubscribeStateChanged!(
                channel, uid, oldState, newState, elapseSinceLastState);
          }
        },
        rtmpStreamingEvent: (url, eventCode) {
          if (agoraEventHandlers.rtmpStreamingEvent != null) {
            agoraEventHandlers.rtmpStreamingEvent!(url, eventCode);
          }
        },
        userSuperResolutionEnabled: (uid, enabled, reason) {
          if (agoraEventHandlers.userSuperResolutionEnabled != null) {
            agoraEventHandlers.userSuperResolutionEnabled!(
                uid, enabled, reason);
          }
        },
        uploadLogResult: (requestId, success, reason) {
          if (agoraEventHandlers.uploadLogResult != null) {
            agoraEventHandlers.uploadLogResult!(requestId, success, reason);
          }
        },
        error: (code) {
          final info = 'onError: $code';
          print(info);
          if (agoraEventHandlers.onError != null) {
            agoraEventHandlers.onError!(code);
          }
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'onJoinChannel: $channel, uid: $uid';
          print(info);
          value = value.copyWith(localUid: uid);
          value = value.copyWith(
            mainAgoraUser: AgoraUser(
              uid: uid,
              remote: false,
              muted: value.isLocalUserMuted,
              videoDisabled: value.isLocalVideoDisabled,
              clientRole: value.clientRole,
            ),
          );
          if (agoraEventHandlers.joinChannelSuccess != null) {
            agoraEventHandlers.joinChannelSuccess!(channel, uid, elapsed);
          }
        },
        leaveChannel: (stats) {
          _clearUsers();
          if (agoraEventHandlers.leaveChannel != null) {
            agoraEventHandlers.leaveChannel!(stats);
          }
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          _addUser(
            callUser: AgoraUser(
              uid: uid,
            ),
          );
          if (agoraEventHandlers.userJoined != null) {
            agoraEventHandlers.userJoined!(uid, elapsed);
          }
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          _checkForMaxUser(uid: uid);
          _removeUser(uid: uid);
          if (agoraEventHandlers.userOffline != null) {
            agoraEventHandlers.userOffline!(uid, reason);
          }
        },
        tokenPrivilegeWillExpire: (token) async {
          await _getToken(
            tokenUrl: value.connectionData!.tokenUrl,
            channelName: value.connectionData!.channelName,
            uid: value.connectionData!.uid,
          );
          await value.engine?.renewToken(token);
          if (agoraEventHandlers.tokenPrivilegeWillExpire != null) {
            agoraEventHandlers.tokenPrivilegeWillExpire!(token);
          }
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          final String info =
              "Remote video state changed for $uid, state: $state and reason: $reason";
          print(info);
          if (uid != value.localUid) {
            if (state == VideoRemoteState.Stopped) {
              _updateUserVideo(uid: uid, videoDisabled: true);
            } else if (state == VideoRemoteState.Decoding &&
                reason == VideoRemoteStateReason.RemoteUnmuted) {
              _updateUserVideo(uid: uid, videoDisabled: false);
            }
          }
          if (agoraEventHandlers.remoteVideoStateChanged != null) {
            agoraEventHandlers.remoteVideoStateChanged!(
                uid, state, reason, elapsed);
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          final String info =
              "Remote audio state changed for $uid, state: $state and reason: $reason";
          print(info);
          if (state == AudioRemoteState.Stopped &&
              reason == AudioRemoteStateReason.RemoteMuted &&
              uid != value.localUid) {
            _updateUserAudio(uid: uid, muted: true);
          } else if (state == AudioRemoteState.Decoding &&
              reason == AudioRemoteStateReason.RemoteUnmuted &&
              uid != value.localUid) {
            _updateUserAudio(uid: uid, muted: false);
          }
          if (agoraEventHandlers.remoteAudioStateChanged != null) {
            agoraEventHandlers.remoteAudioStateChanged!(
                uid, state, reason, elapsed);
          }
        },
        localAudioStateChanged: (state, error) {
          final String info =
              "Local audio state changed state: $state and error: $error";
          print(info);
          if (agoraEventHandlers.localAudioStateChanged != null) {
            agoraEventHandlers.localAudioStateChanged!(state, error);
          }
        },
        localVideoStateChanged: (localVideoState, error) {
          final String info =
              "Local video state changed state: $localVideoState and error: $error";
          print(info);
          if (agoraEventHandlers.localVideoStateChanged != null) {
            agoraEventHandlers.localVideoStateChanged!(localVideoState, error);
          }
        },
        activeSpeaker: (uid) {
          final String info = "Active speaker: $uid";
          print(info);
          if (value.isActiveSpeakerDisabled == false &&
              value.layoutType == Layout.floating) {
            final int index =
                value.users.indexWhere((element) => element.uid == uid);
            swapUser(index: index);
          } else {
            print("Active speaker is disabled");
          }
          if (agoraEventHandlers.activeSpeaker != null) {
            agoraEventHandlers.activeSpeaker!(uid);
          }
        },
      ),
    );
  }

  /// Function to set all the channel properties.
  void setChannelProperties(AgoraChannelData agoraChannelData) async {
    await value.engine?.setChannelProfile(agoraChannelData.channelProfile);
    if (agoraChannelData.channelProfile == ChannelProfile.LiveBroadcasting) {
      await value.engine?.setClientRole(agoraChannelData.clientRole);
    } else {
      print('You can only set channel profile in case of Live Broadcasting');
    }

    value = value.copyWith(
        isActiveSpeakerDisabled: agoraChannelData.isActiveSpeakerDisabled);

    await value.engine
        ?.muteAllRemoteVideoStreams(agoraChannelData.muteAllRemoteVideoStreams);

    await value.engine
        ?.muteAllRemoteAudioStreams(agoraChannelData.muteAllRemoteAudioStreams);

    if (agoraChannelData.setBeautyEffectOptions != null) {
      await value.engine?.setBeautyEffectOptions(
          true, agoraChannelData.setBeautyEffectOptions!);
    }

    await value.engine
        ?.enableDualStreamMode(agoraChannelData.enableDualStreamMode);

    if (agoraChannelData.localPublishFallbackOption != null) {
      await value.engine?.setLocalPublishFallbackOption(
          agoraChannelData.localPublishFallbackOption!);
    }

    if (agoraChannelData.remoteSubscribeFallbackOption != null) {
      await value.engine?.setRemoteSubscribeFallbackOption(
          agoraChannelData.remoteSubscribeFallbackOption!);
    }

    if (agoraChannelData.videoEncoderConfiguration != null) {
      await value.engine?.setVideoEncoderConfiguration(
          agoraChannelData.videoEncoderConfiguration!);
    }

    await value.engine?.setCameraAutoFocusFaceModeEnabled(
        agoraChannelData.setCameraAutoFocusFaceModeEnabled);

    await value.engine?.setCameraTorchOn(agoraChannelData.setCameraTorchOn);

    await value.engine?.setAudioProfile(
        agoraChannelData.audioProfile, agoraChannelData.audioScenario);
  }

  Future<void> joinVideoChannel() async {
    await value.engine?.enableVideo();
    await value.engine?.enableAudioVolumeIndication(200, 3, true);
    if (value.connectionData!.tokenUrl != null) {
      await _getToken(
        tokenUrl: value.connectionData!.tokenUrl,
        channelName: value.connectionData!.channelName,
        uid: value.connectionData!.uid,
      );
    }
    await value.engine?.joinChannel(
      value.connectionData!.tempToken ?? value.generatedToken,
      value.connectionData!.channelName,
      null,
      value.connectionData!.uid,
    );
  }

  void _addUser({required AgoraUser callUser}) {
    value = value.copyWith(users: [...value.users, callUser]);
  }

  void _clearUsers() {
    value = value.copyWith(users: []);
  }

  void _removeUser({required int uid}) {
    List<AgoraUser> tempList = <AgoraUser>[];
    tempList = value.users;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = value.copyWith(users: tempList);
  }

  /// Function to mute/unmute the microphone
  Future<void> toggleMute() async {
    var status = await Permission.microphone.status;
    if (value.isLocalUserMuted && status.isDenied) {
      await Permission.microphone.request();
    }
    value = value.copyWith(isLocalUserMuted: !(value.isLocalUserMuted));
    await value.engine?.muteLocalAudioStream(value.isLocalUserMuted);
  }

  /// Function to toggle enable/disable the camera
  Future<void> toggleCamera() async {
    var status = await Permission.camera.status;
    if (value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    value = value.copyWith(isLocalVideoDisabled: !(value.isLocalVideoDisabled));
    await value.engine?.muteLocalVideoStream(value.isLocalVideoDisabled);
  }

  /// Function to switch between front and rear camera
  Future<void> switchCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    await value.engine?.switchCamera();
  }

  Future<void> endCall() async {
    await value.engine?.leaveChannel();
    await value.engine?.destroy();
    // dispose();
  }

  Timer? timer;

  /// Function to auto hide the button class.
  void toggleVisible({int autoHideButtonTime = 5}) async {
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

  void _checkForMaxUser({int? uid}) {
    if (uid == value.mainAgoraUser.uid) {
      value = value.copyWith(
        mainAgoraUser: AgoraUser(
          uid: value.localUid,
          remote: false,
          muted: value.isLocalUserMuted,
          videoDisabled: value.isLocalVideoDisabled,
          clientRole: ClientRole.Broadcaster,
        ),
      );
    }
    _removeUser(uid: value.localUid);
  }

  void _updateUserVideo({required int uid, required bool videoDisabled}) {
    // if local user updates video
    if (uid == value.localUid) {
      value = value.copyWith(isLocalVideoDisabled: videoDisabled);
      // if remote user updates video
    } else {
      List<AgoraUser> tempList = value.users;
      int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
      if (indexOfUser == -1) return; //this means user is no longer in the call
      tempList[indexOfUser] =
          tempList[indexOfUser].copyWith(videoDisabled: videoDisabled);
      value = value.copyWith(users: tempList);
    }
  }

  void _updateUserAudio({required int uid, required bool muted}) {
    // if local user updates audio
    if (uid == value.localUid) {
      value = value.copyWith(isLocalUserMuted: muted);
      // if remote user updates audio
    } else {
      List<AgoraUser> tempList = value.users;
      int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
      if (indexOfUser == -1) return; //this means user is no longer in the call
      tempList[indexOfUser] = tempList[indexOfUser].copyWith(muted: muted);
      value = value.copyWith(users: tempList);
    }
  }

  /// Function to swap [AgoraUser] in the floating layout.
  void swapUser({required int index}) {
    final AgoraUser newUser = value.users[index];
    final AgoraUser tempAgoraUser = value.mainAgoraUser;
    value = value.copyWith(mainAgoraUser: newUser);
    _addUser(callUser: tempAgoraUser);
    _removeUser(uid: newUser.uid);
  }

  Future<void> _getToken({
    String? tokenUrl,
    String? channelName,
    int uid = 0,
  }) async {
    final response = await http
        .get(Uri.parse('$tokenUrl/rtc/$channelName/publisher/uid/$uid'));
    if (response.statusCode == 200) {
      value =
          value.copyWith(generatedToken: jsonDecode(response.body)['rtcToken']);
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }

  void updateLayoutType({required Layout updatedLayout}) {
    value = value.copyWith(layoutType: updatedLayout);
  }
}
