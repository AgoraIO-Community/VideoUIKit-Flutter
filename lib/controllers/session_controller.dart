import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_event_handlers.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/models/rtm_message.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../src/enums.dart';

class SessionController extends ValueNotifier<AgoraSettings> {
  SessionController()
      : super(
          AgoraSettings(
            engine: null,
            agoraRtmChannel: null,
            agoraRtmClient: null,
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
            generatedRtmId: null,
            layoutType: Layout.grid,
            displaySnackbar: false,
            muteRequest: MicState.unmuted,
            cameraRequest: CameraState.enabled,
            showMicMessage: false,
            showCameraMessage: false,
          ),
        );

  /// Function to initialize the Agora RTM client.
  Future<void> initializeRtm() async {
    value = value.copyWith(
      agoraRtmClient: await AgoraRtmClient.createInstance(
        value.connectionData!.appId,
      ),
    );

    value.agoraRtmClient?.onMessageReceived =
        (AgoraRtmMessage message, String peerId) {
      print('Peer msg : $message, from : $peerId');
      Message msg = Message(text: message.text);

      String? messageType;
      msg.toJson().forEach((key, val) {
        if (key == "text") {
          var json = jsonDecode(val);
          messageType = json['messageType'];
        }
      });
      _onMessageReceived(messageType: messageType!, message: msg.toJson());
    };

    value.agoraRtmClient?.onConnectionStateChanged = (int state, int reason) {
      print(
          'Connection state changed : ${state.toString()}, reason : ${reason.toString()}');
      if (state == 5) {
        value.agoraRtmClient?.logout();
      }
    };

    value.agoraRtmClient?.onLocalInvitationReceivedByPeer =
        (AgoraRtmLocalInvitation invitation) {
      print(
          'Local invitation received by peer : ${invitation.calleeId}, content : ${invitation.content}');
    };

    value.agoraRtmClient?.onRemoteInvitationReceivedByPeer =
        (AgoraRtmRemoteInvitation invitation) {
      print(
          'Remote invitation received by peer : ${invitation.callerId}, content : ${invitation.content}');
    };

    value.agoraRtmClient?.onError = () {
      print('Error Occurred');
    };
  }

  /// Function to join the RTM channel and send the user data to everyone inside that channel.
  Future<void> rtmMethods() async {
    await _loginToRtm();
    await _joinRtmChannel();
    await _sendUserData(
      toChannel: true,
      username: value.connectionData!.username!,
    );
  }

  /// Function to initialize the Agora RTC engine.
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

  Future<void> askForUserCameraAndMicPermission() async {
    await [Permission.camera, Permission.microphone].request();
  }

  /// Function to trigger all the AgoraEventHandlers.
  void createEvents(AgoraEventHandlers agoraEventHandlers) async {
    value.engine?.setEventHandler(
      RtcEngineEventHandler(
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
          agoraEventHandlers.videoSizeChanged
              ?.call(uid, width, height, rotation);
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
          agoraEventHandlers.rtmpStreamingStateChanged
              ?.call(url, state, errCode);
        },
        transcodingUpdated: () {
          agoraEventHandlers.transcodingUpdated?.call();
        },
        streamInjectedStatus: (url, uid, status) {
          agoraEventHandlers.streamInjectedStatus?.call(url, uid, status);
        },
        streamMessage: (uid, streamId, data) {
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
        metadataReceived: (buffer, uid, timeStampMs) {
          agoraEventHandlers.metadataReceived?.call(buffer, uid, timeStampMs);
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
          agoraEventHandlers.userSuperResolutionEnabled
              ?.call(uid, enabled, reason);
        },
        uploadLogResult: (requestId, success, reason) {
          agoraEventHandlers.uploadLogResult?.call(requestId, success, reason);
        },
        error: (code) {
          final info = 'onError: $code';
          print(info);

          agoraEventHandlers.onError?.call(code);
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
          if (value.connectionData!.username != null) {
            rtmMethods();
          }
          agoraEventHandlers.joinChannelSuccess?.call(channel, uid, elapsed);
        },
        leaveChannel: (stats) {
          _clearUsers();
          agoraEventHandlers.leaveChannel?.call(stats);
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          _addUser(
            callUser: AgoraUser(
              uid: uid,
            ),
          );

          agoraEventHandlers.userJoined?.call(uid, elapsed);
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          _checkForMaxUser(uid: uid);
          _removeUser(uid: uid);

          agoraEventHandlers.userOffline?.call(uid, reason);
        },
        tokenPrivilegeWillExpire: (token) async {
          await _getToken(
            tokenUrl: value.connectionData!.tokenUrl,
            channelName: value.connectionData!.channelName,
            uid: value.connectionData!.uid,
          );
          await value.engine?.renewToken(token);

          agoraEventHandlers.tokenPrivilegeWillExpire?.call(token);
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

          agoraEventHandlers.remoteVideoStateChanged
              ?.call(uid, state, reason, elapsed);
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

          agoraEventHandlers.remoteAudioStateChanged
              ?.call(uid, state, reason, elapsed);
        },
        localAudioStateChanged: (state, error) {
          final String info =
              "Local audio state changed state: $state and error: $error";
          print(info);

          agoraEventHandlers.localAudioStateChanged?.call(state, error);
        },
        localVideoStateChanged: (localVideoState, error) {
          final String info =
              "Local video state changed state: $localVideoState and error: $error";
          print(info);

          agoraEventHandlers.localVideoStateChanged
              ?.call(localVideoState, error);
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

          agoraEventHandlers.activeSpeaker?.call(uid);
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

  /// Function to join the video call.
  Future<void> joinVideoChannel() async {
    // [generatedRtmId] is the unique ID for a user generated using the timestamp in milliseconds.
    value = value.copyWith(
      generatedRtmId: value.connectionData!.rtmUid ??
          DateTime.now().millisecondsSinceEpoch.toString(),
    );
    await value.engine?.enableVideo();
    await value.engine?.enableAudioVolumeIndication(200, 3, true);
    if (value.connectionData?.tokenUrl != null) {
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

  /// Function to dispose the RTC and RTM engine.
  Future<void> endCall() async {
    await value.engine?.leaveChannel();
    if (value.connectionData!.username != null) {
      await value.agoraRtmChannel?.leave();
      await value.agoraRtmClient?.logout();
    }
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
    if (value.connectionData!.username != null) {
      await _getRtmToken(tokenUrl: tokenUrl);
    }
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

  Future<void> _getRtmToken({String? tokenUrl}) async {
    final String url = "$tokenUrl/rtm/${value.generatedRtmId}";
    final rtmResponse = await http.get(Uri.parse(url));
    print(url);
    if (rtmResponse.statusCode == 200) {
      value = value.copyWith(
        generatedRtmToken: jsonDecode(rtmResponse.body)['rtmToken'],
      );
    } else {
      print(rtmResponse.reasonPhrase);
      print('Failed to generate the rtm token : ${rtmResponse.statusCode}');
    }
  }

  void updateLayoutType({required Layout updatedLayout}) {
    value = value.copyWith(layoutType: updatedLayout);
  }

  Future<void> _loginToRtm() async {
    if (!value.isLoggedIn) {
      try {
        await value.agoraRtmClient?.login(
          value.connectionData!.tempRtmToken ?? value.generatedRtmToken,
          value.generatedRtmId!,
        );
        value = value.copyWith(isLoggedIn: true);
        print(
            'Username : ${value.connectionData!.username} and rtmId : ${value.generatedRtmId} logged in');
      } catch (e) {
        print('Error occurred while trying to login. ${e.toString()}');
      }
    }
  }

  Future<AgoraRtmChannel?> _createChannel(
      {required String rtmChannelName}) async {
    AgoraRtmChannel? channel =
        await value.agoraRtmClient?.createChannel(rtmChannelName);

    if (channel != null) {
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        print('Channel msg : ${message.text}, from : ${member.userId}');
        Message msg = Message(text: message.text);
        _onMessageReceived(messageType: "UserData", message: msg.toJson());
      };

      channel.onMemberJoined = (AgoraRtmMember member) {
        print('Member joined : ${member.userId}');
        _sendUserData(
          toChannel: false,
          username: value.connectionData!.username!,
          peerRtmId: member.userId,
        );
      };

      channel.onMemberLeft = (AgoraRtmMember member) {
        print('Member left : ${member.userId}');

        if (value.userRtmMap!.containsKey(member.userId)) {
          _removeFromUserRtmMap(rtmId: member.userId);
        }

        if (value.uidToUserIdMap!.containsValue(member.userId)) {
          for (var i = 0; i < value.uidToUserIdMap!.length; i++) {
            int rtcId = value.uidToUserIdMap!.keys.elementAt(i);
            _removeFromUidToUserMap(rtcId: rtcId);
          }
        }
      };

      channel.onMemberCountUpdated = (int count) {
        print('Member count updated : $count');
      };
    }
    return channel;
  }

  Future<void> _joinRtmChannel() async {
    if (!value.isInChannel) {
      try {
        value = value.copyWith(
          agoraRtmChannel: await _createChannel(
              rtmChannelName: value.connectionData?.rtmChannelName ??
                  value.connectionData!.channelName),
        );
        await value.agoraRtmChannel?.join();
        value = value.copyWith(isInChannel: true);
      } catch (e) {
        print('RTM Join channel error : ${e.toString()}');
      }
    }
  }

  Future<void> _sendUserData({
    required bool toChannel,
    required String username,
    String? peerRtmId,
  }) async {
    String platform = Platform.isAndroid ? "android" : "ios";
    int ts = DateTime.now().millisecondsSinceEpoch;

    String json = '''{
      "messageType": "UserData",
      "rtmId": "${value.generatedRtmId}",
      "rtcId": ${value.localUid},
      "username": "$username",
      "role": "${value.clientRole}",
      "agora": {
        "rtm": "1.0.1",
        "rtc": "4.0.6"
      },
      "uikit": {
        "platform": "$platform",
        "framework": "flutter",
        "version": "1.0.0"
      }
    }''';

    Message message = Message(text: json, ts: ts, offline: false);
    AgoraRtmMessage msg = AgoraRtmMessage.fromJson(message.toJson());

    if (value.agoraRtmChannel != null && toChannel) {
      await value.agoraRtmChannel?.sendMessage(msg);
      print('User data sent to channel');
    } else if (value.agoraRtmClient != null &&
        !toChannel &&
        peerRtmId != null) {
      await value.agoraRtmClient?.sendMessageToPeer(peerRtmId, msg);
      print('User data sent to peer');
    } else {
      print("No user in the channel");
    }
  }

  void askForUserMic({required int index, required bool isMicEnabled}) {
    String? peerId;
    String json = '''{
      "messageType": "MuteRequest",
      "rtcId": ${value.users[index].uid},
      "mute": $isMicEnabled,
      "device": "0", 
      "isForceFul": "false"
    }''';

    Message message = Message(text: json);
    AgoraRtmMessage msg = AgoraRtmMessage.fromJson(message.toJson());
    value.uidToUserIdMap!.forEach((key, val) {
      if (key == value.users[index].uid) {
        peerId = val;
        print("PEER RTM ID : $peerId");
        if (value.isLoggedIn) {
          value.agoraRtmClient?.sendMessageToPeer(peerId!, msg);
        } else {
          print("USER NOT LOGGED IN (MIC)");
        }
      } else {
        print("Peer RTM ID not found");
      }
    });
  }

  void askForUserCamera({required int index, required bool isCameraEnabled}) {
    String? peerId;
    String json = '''{
      "messageType": "CameraRequest",
      "rtcId": ${value.users[index].uid},
      "mute": $isCameraEnabled,
      "device": "1",
      "isForceFul": "false"
    }''';

    Message message = Message(text: json);
    AgoraRtmMessage msg = AgoraRtmMessage.fromJson(message.toJson());
    value.uidToUserIdMap!.forEach((key, val) {
      if (key == value.users[index].uid) {
        peerId = val;
        value.agoraRtmClient?.sendMessageToPeer(peerId!, msg);
      } else {
        print("Peer RTM ID not found");
      }
    });
  }

  void _addToUidUserMap({required int rtcId, required String rtmId}) {
    Map<int, String> tempMap = {};
    tempMap.addAll(value.uidToUserIdMap ?? {});
    if (rtcId != 0) {
      tempMap.putIfAbsent(rtcId, () => rtmId);
    }
    value = value.copyWith(uidToUserIdMap: tempMap);
  }

  void _addToUserRtmMap(
      {required String rtmId, required Map<String, dynamic> message}) {
    Map<String, Map<String, dynamic>> tempMap = {};
    tempMap.addAll(value.userRtmMap ?? {});
    tempMap.putIfAbsent(rtmId, () => message);
    value = value.copyWith(userRtmMap: tempMap);
  }

  void _removeFromUidToUserMap({required int rtcId}) {
    Map<int, String> tempMap = {};
    tempMap = value.uidToUserIdMap!;
    for (int i = 0; i < tempMap.length; i++) {
      if (tempMap.keys.elementAt(i) == rtcId) {
        tempMap.remove(rtcId);
      }
    }
    value = value.copyWith(uidToUserIdMap: tempMap);
  }

  void _removeFromUserRtmMap({required String rtmId}) {
    Map<String, Map<String, dynamic>> tempMap = {};
    tempMap = value.userRtmMap!;
    for (int i = 0; i < tempMap.length; i++) {
      if (tempMap.keys.elementAt(i) == rtmId) {
        tempMap.remove(rtmId);
      }
    }
    value = value.copyWith(userRtmMap: tempMap);
  }

  void _onMessageReceived(
      {required String messageType, required Map<String, dynamic> message}) {
    switch (messageType) {
      case "UserData":
        print('User data received: $message');
        message.forEach((key, val) {
          if (key == "text") {
            var json = jsonDecode(val);
            String rtmId = json['rtmId'];
            int rtcId = json['rtcId'];
            print("RTM ID: $rtmId");
            print("RTC ID : $rtcId");
            _addToUidUserMap(rtcId: rtcId, rtmId: rtmId);
            _addToUserRtmMap(rtmId: rtmId, message: message);
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
            print("RTC ID: $rtcId");
          }
        });
        value = value.copyWith(
          displaySnackbar: true,
          muteRequest: muted! ? MicState.unmuted : MicState.muted,
          showCameraMessage: false,
          showMicMessage: true,
        );
        Future.delayed(Duration(seconds: 10), () {
          value = value.copyWith(
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
            print("RTC ID: $rtcId");
          }
        });
        value = value.copyWith(
          displaySnackbar: true,
          cameraRequest: disabled! ? CameraState.enabled : CameraState.disabled,
          showMicMessage: false,
          showCameraMessage: true,
        );
        Future.delayed(Duration(seconds: 10), () {
          value = value.copyWith(
            displaySnackbar: false,
            showCameraMessage: false,
          );
        });
        break;
      default:
    }
  }
}
