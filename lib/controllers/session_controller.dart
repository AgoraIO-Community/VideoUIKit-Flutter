import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_uikit/controllers/rtc_event_handlers.dart';
import 'package:agora_uikit/controllers/rtc_token_handler.dart';
import 'package:agora_uikit/controllers/rtm_client_event_handler.dart';
import 'package:agora_uikit/controllers/rtm_token_handler.dart';
import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_rtc_event_handlers.dart';
import 'package:agora_uikit/models/agora_rtm_channel_event_handler.dart';
import 'package:agora_uikit/models/agora_rtm_client_event_handler.dart';
import 'package:agora_uikit/models/agora_rtm_mute_request.dart';
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
            engine: createAgoraRtcEngine(),
            agoraRtmChannel: null,
            agoraRtmClient: null,
            users: [],
            mainAgoraUser: AgoraUser(
              uid: 0,
              remote: true,
              muted: false,
              videoDisabled: false,
              clientRoleType: ClientRoleType.clientRoleBroadcaster,
            ),
            isLocalUserMuted: false,
            isLocalVideoDisabled: false,
            visible: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
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
  Future<void> initializeRtm(
      AgoraRtmClientEventHandler agoraRtmClientEventHandler) async {
    value = value.copyWith(
      agoraRtmClient: await AgoraRtmClient.createInstance(
        value.connectionData!.appId,
      ),
    );
    if (value.agoraRtmClient != null) {
      addListener(() {
        createRtmClientEvents(agoraRtmClientEventHandler);
      });
    }
  }

  /// Function to initialize the Agora RTC engine.
  Future<void> initializeEngine(
      {required AgoraConnectionData agoraConnectionData}) async {
    value = value.copyWith(connectionData: agoraConnectionData);

    await value.engine!
        .initialize(RtcEngineContext(appId: value.connectionData!.appId));
    log("SDK initialized: ${value.engine}", level: Level.error.value);
    // Getting SDK versions and assigning them
    SDKBuildInfo? rtcVersion = await value.engine?.getVersion();
    AgoraVersions.staticRTM = await AgoraRtmClient.getSdkVersion();
    if (rtcVersion?.version.toString() != null) {
      AgoraVersions.staticRTC = rtcVersion!.version.toString();
    }
  }

  Future<void> askForUserCameraAndMicPermission() async {
    await [Permission.camera, Permission.microphone].request();
  }

  /// Function to trigger all the AgoraRtcEventHandlers.
  void createEvents(
    AgoraRtmChannelEventHandler agoraRtmChannelEventHandler,
    AgoraRtcEventHandlers agoraEventHandlers,
  ) async {
    value.engine?.registerEventHandler(
      await rtcEngineEventHandler(
        agoraEventHandlers,
        agoraRtmChannelEventHandler,
        this,
      ),
    );
  }

  void createRtmClientEvents(
      AgoraRtmClientEventHandler agoraRtmClientEventHandler) {
    rtmClientEventHandler(
      agoraRtmClient: value.agoraRtmClient!,
      agoraRtmClientEventHandler: agoraRtmClientEventHandler,
      sessionController: this,
    );
  }

  /// Function to set all the channel properties.
  void setChannelProperties(AgoraChannelData agoraChannelData) async {
    await value.engine?.setChannelProfile(agoraChannelData.channelProfileType);
    if (agoraChannelData.channelProfileType ==
        ChannelProfileType.channelProfileLiveBroadcasting) {
      await value.engine?.setClientRole(role: agoraChannelData.clientRoleType);
    } else {
      log('You can only set channel profile in case of Live Broadcasting',
          level: Level.warning.value);
    }

    value = value.copyWith(
        isActiveSpeakerDisabled: agoraChannelData.isActiveSpeakerDisabled);

    await value.engine
        ?.muteAllRemoteVideoStreams(agoraChannelData.muteAllRemoteVideoStreams);

    await value.engine
        ?.muteAllRemoteAudioStreams(agoraChannelData.muteAllRemoteAudioStreams);

    if (agoraChannelData.setBeautyEffectOptions != null) {
      await value.engine?.setBeautyEffectOptions(
          enabled: true, options: agoraChannelData.setBeautyEffectOptions!);
    }

    await value.engine
        ?.enableDualStreamMode(enabled: agoraChannelData.enableDualStreamMode);

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
        profile: agoraChannelData.audioProfileType,
        scenario: agoraChannelData.audioScenarioType);
  }

  /// Function to join the video call.
  Future<void> joinVideoChannel() async {
    if (value.layoutType == Layout.oneToOne && value.users.length == 1) return;

    // [generatedRtmId] is the unique ID for a user generated using the timestamp in milliseconds.
    value = value.copyWith(
      generatedRtmId: value.connectionData!.rtmUid ??
          DateTime.now().millisecondsSinceEpoch.toString(),
    );
    await value.engine?.setParameters("{\"rtc.using_ui_kit\": 1}");
    await value.engine?.enableVideo();
    await value.engine?.enableAudioVolumeIndication(
        interval: 200, smooth: 3, reportVad: true);
    if (value.connectionData?.tokenUrl != null) {
      await getToken(
        tokenUrl: value.connectionData!.tokenUrl,
        channelName: value.connectionData!.channelName,
        uid: value.connectionData!.uid,
        sessionController: this,
      );
      if (value.connectionData!.rtmEnabled) {
        await getRtmToken(
          tokenUrl: value.connectionData!.tokenUrl,
          sessionController: this,
        );
      }
    }

    await value.engine?.startPreview();

    await value.engine?.joinChannel(
      token: value.connectionData?.tempToken ?? value.generatedToken ?? "",
      channelId: value.connectionData!.channelName,
      uid: value.connectionData!.uid!,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void addUser({required AgoraUser callUser}) {
    value = value.copyWith(users: [...value.users, callUser]);
  }

  void clearUsers() {
    value = value.copyWith(users: []);
  }

  void removeUser({required int uid}) {
    List<AgoraUser> tempList = <AgoraUser>[];
    tempList = value.users;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = value.copyWith(users: tempList);
  }

  void checkForMaxUser({int? uid}) {
    if (uid == value.mainAgoraUser.uid) {
      value = value.copyWith(
        mainAgoraUser: AgoraUser(
          uid: value.localUid,
          remote: false,
          muted: value.isLocalUserMuted,
          videoDisabled: value.isLocalVideoDisabled,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    }
    removeUser(uid: value.localUid);
  }

  void updateUserVideo({required int uid, required bool videoDisabled}) {
    // if local user updates video
    if (uid == value.localUid) {
      value = value.copyWith(isLocalVideoDisabled: videoDisabled);
      // if remote user updates video
    } else if (uid == value.mainAgoraUser.uid) {
      value = value.copyWith(
          mainAgoraUser: AgoraUser(uid: uid, videoDisabled: videoDisabled));
    } else {
      List<AgoraUser> tempList = value.users;
      int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
      if (indexOfUser == -1) return; //this means user is no longer in the call
      tempList[indexOfUser] =
          tempList[indexOfUser].copyWith(videoDisabled: videoDisabled);
      value = value.copyWith(users: tempList);
    }
  }

  void updateUserAudio({required int uid, required bool muted}) {
    // if local user updates audio
    if (uid == value.localUid) {
      value = value.copyWith(isLocalUserMuted: muted);
      // if remote user updates audio
    } else if (uid == value.mainAgoraUser.uid) {
      value = value.copyWith(mainAgoraUser: AgoraUser(uid: uid, muted: muted));
    } else {
      List<AgoraUser> tempList = value.users;
      int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
      if (indexOfUser == -1) return; //this means user is no longer in the call
      tempList[indexOfUser] = tempList[indexOfUser].copyWith(muted: muted);
      value = value.copyWith(users: tempList);
    }
  }

  /// Function to disableActiveSpeaker
  void setActiveSpeakerDisabled(bool activeSpeakerDisabled) {
    value = value.copyWith(isActiveSpeakerDisabled: activeSpeakerDisabled);
  }

  /// Function to swap [AgoraUser] in the floating layout.
  void swapUser({required int index}) {
    final AgoraUser newUser = value.users[index];
    final AgoraUser tempAgoraUser = value.mainAgoraUser;
    value = value.copyWith(mainAgoraUser: newUser);
    addUser(callUser: tempAgoraUser);
    removeUser(uid: newUser.uid);
  }

  void updateLayoutType({required Layout updatedLayout}) {
    value = value.copyWith(layoutType: updatedLayout);
  }

  Future<void> startCloudRecording(
      {required AgoraConnectionData connectionData}) async {
    final response = await http.post(
      Uri.parse(
          '${connectionData.cloudRecordingUrl}/start-recording/${connectionData.channelName}'),
    );

    if (response.statusCode == HttpStatus.ok) {
      value = value.copyWith(
        sid: jsonDecode(response.body)['sid'],
        resourceId: jsonDecode(response.body)['resource_id'],
      );
      log('Recording Started with SID ${value.sid} and RESOURCE ID: ${value.resourceId}',
          level: Level.warning.value);
    } else {
      log('Couldn\'t start the recording : ${response.statusCode}',
          level: Level.error.value);
    }
  }

  Future<void> stopCloudRecording(
      {required AgoraConnectionData connectionData}) async {
    final response = await http.post(
      Uri.parse(
          '${connectionData.cloudRecordingUrl}/stop-recording/${connectionData.channelName}/${value.sid}/${value.resourceId}'),
    );

    if (response.statusCode == HttpStatus.ok) {
      log('Recording Ended', level: Level.warning.value);
      if (connectionData.cloudRecordingCallback != null) {
        connectionData.cloudRecordingCallback!(
            jsonDecode(response.body)['mp4_link'],
            jsonDecode(response.body)['m3u8_link']);
      }
    } else {
      log('Couldn\'t end the recording : ${response.statusCode}',
          level: Level.error.value);
    }
  }
}
