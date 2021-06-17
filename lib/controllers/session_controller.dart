import 'dart:async';
import 'dart:convert';

import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_event_handlers.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

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
          ),
        );

  void initializeEngine(
      {required AgoraConnectionData agoraConnectionData}) async {
    value = value.copyWith(
      engine: await RtcEngine.createWithConfig(
        RtcEngineConfig(agoraConnectionData.appId,
            areaCode: agoraConnectionData.areaCode),
      ),
      connectionData: agoraConnectionData,
    );
  }

  void createEvents(AgoraEventHandlers? agoraEventHandlers) async {
    value.engine?.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'onError: $code';
          print(info);
          var onErrorFun = agoraEventHandlers?.onError;
          if (onErrorFun != null) onErrorFun(code);
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
          var joinChannelSuccessFun = agoraEventHandlers?.joinChannelSuccess;
          if (joinChannelSuccessFun != null) {
            joinChannelSuccessFun(channel, uid, elapsed);
          }
        },
        leaveChannel: (stats) {
          _clearUsers();
          var leaveChannelFun = agoraEventHandlers?.leaveChannel;
          if (leaveChannelFun != null) leaveChannelFun(stats);
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          _addUser(
            callUser: AgoraUser(
              uid: uid,
            ),
          );
          var userJoinedFun = agoraEventHandlers?.userJoined;
          if (userJoinedFun != null) userJoinedFun(uid, elapsed);
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          _checkForMaxUser(uid: uid);
          _removeUser(uid: uid);
          var userOfflineFun = agoraEventHandlers?.userOffline;
          if (userOfflineFun != null) userOfflineFun(uid, reason);
        },
        tokenPrivilegeWillExpire: (token) async {
          await _getToken(
            tokenUrl: value.connectionData!.tokenUrl,
            channelName: value.connectionData!.channelName,
            uid: value.connectionData!.uid,
          );
          await value.engine?.renewToken(token);
          var tokenPrivilegeWillExpireFun =
              agoraEventHandlers?.tokenPrivilegeWillExpire;
          if (tokenPrivilegeWillExpireFun != null) {
            tokenPrivilegeWillExpireFun(token);
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
          var remoteVideoStateChangedFun =
              agoraEventHandlers?.remoteVideoStateChanged;
          if (remoteVideoStateChangedFun != null) {
            remoteVideoStateChangedFun(uid, state, reason, elapsed);
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          final String info =
              "Remote audio state changed for $uid, state: $state and reason: $reason";
          print(info);
          if (state == AudioRemoteState.Stopped &&
              reason == AudioRemoteStateReason.RemoteMuted) {
            _updateUserAudio(uid: uid, muted: true);
          } else if (state == AudioRemoteState.Decoding &&
              reason == AudioRemoteStateReason.RemoteUnmuted) {
            _updateUserAudio(uid: uid, muted: false);
          }
          var remoteAudioStateChangedFun =
              agoraEventHandlers?.remoteAudioStateChanged;
          if (remoteAudioStateChangedFun != null) {
            remoteAudioStateChangedFun(uid, state, reason, elapsed);
          }
        },
        localAudioStateChanged: (state, error) {
          final String info =
              "Local audio state changed state: $state and error: $error";
          print(info);
          var localAudioStateChangedFun =
              agoraEventHandlers?.localAudioStateChanged;
          if (localAudioStateChangedFun != null) {
            localAudioStateChangedFun(state, error);
          }
        },
        localVideoStateChanged: (localVideoState, error) {
          final String info =
              "Local audio state changed state: $localVideoState and error: $error";
          print(info);
          var localVideoStateChangedFun =
              agoraEventHandlers?.localVideoStateChanged;
          if (localVideoStateChangedFun != null) {
            localVideoStateChangedFun(localVideoState, error);
          }
        },
        activeSpeaker: (uid) {
          final String info = "Active speaker: $uid";
          print(info);
          if (value.isActiveSpeakerDisabled == false) {
            final int index =
                value.users.indexWhere((element) => element.uid == uid);
            swapUser(index: index);
          } else {
            print("Active speaker is disabled");
          }
          var activeSpeakerFun = agoraEventHandlers?.activeSpeaker;
          if (activeSpeakerFun != null) activeSpeakerFun(uid);
        },
      ),
    );
  }

  /// Function to set all the channel properties.
  void setChannelProperties(AgoraChannelData agoraChannelData) async {
    await value.engine?.setChannelProfile(
        agoraChannelData.channelProfile ?? ChannelProfile.Communication);

    if (agoraChannelData.channelProfile == ChannelProfile.LiveBroadcasting) {
      await value.engine?.setClientRole(
          agoraChannelData.clientRole ?? ClientRole.Broadcaster);
    } else {
      print('You can only set channel profile in case of Live Broadcasting');
    }

    value = value.copyWith(
        isActiveSpeakerDisabled: agoraChannelData.isActiveSpeakerDisabled);

    await value.engine?.muteAllRemoteVideoStreams(
        agoraChannelData.muteAllRemoteVideoStreams ?? false);

    await value.engine?.muteAllRemoteAudioStreams(
        agoraChannelData.muteAllRemoteAudioStreams ?? false);

    if (agoraChannelData.setBeautyEffectOptions != null) {
      value.engine?.setBeautyEffectOptions(
          true, agoraChannelData.setBeautyEffectOptions!);
    }

    await value.engine
        ?.enableDualStreamMode(agoraChannelData.enableDualStreamMode ?? false);

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

    value.engine?.setCameraAutoFocusFaceModeEnabled(
        agoraChannelData.setCameraAutoFocusFaceModeEnabled ?? false);

    value.engine?.setCameraTorchOn(agoraChannelData.setCameraTorchOn ?? false);

    await value.engine?.setAudioProfile(
        agoraChannelData.audioProfile ?? AudioProfile.Default,
        agoraChannelData.audioScenario ?? AudioScenario.Default);
  }

  void joinVideoChannel() async {
    await value.engine?.enableVideo();
    await value.engine?.enableAudioVolumeIndication(200, 3, true);
    if (value.connectionData!.tokenUrl != null) {
      await _getToken(
        tokenUrl: value.connectionData!.tokenUrl,
        channelName: value.connectionData!.channelName,
        uid: value.connectionData!.uid,
      );
    }
    value.engine?.joinChannel(
      value.connectionData!.tempToken ?? value.generatedToken,
      value.connectionData!.channelName,
      null,
      value.connectionData!.uid ?? 0,
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
  void toggleMute() async {
    var status = await Permission.microphone.status;
    if (value.isLocalUserMuted && status.isDenied) {
      await Permission.microphone.request();
    }
    value = value.copyWith(isLocalUserMuted: !(value.isLocalUserMuted));
    value.engine?.muteLocalAudioStream(value.isLocalUserMuted);
  }

  /// Function to toggle enable/disable the camera
  void toggleCamera() async {
    var status = await Permission.camera.status;
    if (value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    value = value.copyWith(isLocalVideoDisabled: !(value.isLocalVideoDisabled));
    value.engine?.muteLocalVideoStream(value.isLocalVideoDisabled);
  }

  /// Function to switch between front and rear camera
  void switchCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    value.engine?.switchCamera();
  }

  void endCall() {
    value.engine?.leaveChannel();
    value.engine?.destroy();
    // dispose();
  }

  Timer? timer;

  /// Function to auto hide the button class.
  void toggleVisible({int? autoHideButtonTime}) async {
    if (!(value.visible)) {
      value = value.copyWith(visible: !(value.visible));
      timer = Timer(Duration(seconds: autoHideButtonTime ?? 5), () {
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
  Future<void> swapUser({required int index}) async {
    final AgoraUser newUser = value.users[index];
    final AgoraUser tempAgoraUser = value.mainAgoraUser;
    value = value.copyWith(mainAgoraUser: newUser);
    _addUser(callUser: tempAgoraUser);
    _removeUser(uid: newUser.uid);
  }

  Future<void> _getToken(
      {String? tokenUrl, String? channelName, int? uid}) async {
    uid = uid ?? 0;
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
}
