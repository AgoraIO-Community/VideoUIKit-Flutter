import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/src/enums.dart';

import 'agora_user.dart';

class AgoraSettings {
  final RtcEngine? engine;
  final AgoraConnectionData? connectionData;
  final List<AgoraUser> users;
  final AgoraUser mainAgoraUser;
  final bool isLocalUserMuted;
  final bool isLocalVideoDisabled;
  final bool visible;
  final ClientRole clientRole;
  final int localUid;
  String? generatedToken;
  final bool isActiveSpeakerDisabled;
  final Layout layoutType;
  String? rid;
  String? sid;
  String? mode;
  ChannelProfile? channelProfile;
  final bool isRecording;

  AgoraSettings({
    this.engine,
    this.connectionData,
    required this.users,
    required this.mainAgoraUser,
    required this.isLocalUserMuted,
    required this.isLocalVideoDisabled,
    required this.visible,
    required this.clientRole,
    required this.localUid,
    this.rid,
    this.sid,
    this.mode = 'mix',
    this.generatedToken,
    this.isActiveSpeakerDisabled = false,
    this.layoutType = Layout.grid,
    this.isRecording = false,
  });

  AgoraSettings copyWith({
    RtcEngine? engine,
    AgoraConnectionData? connectionData,
    List<AgoraUser>? users,
    AgoraUser? mainAgoraUser,
    bool? isLocalUserMuted,
    bool? isLocalVideoDisabled,
    bool? visible,
    ClientRole? clientRole,
    int? localUid,
    String? generatedToken,
    bool? isActiveSpeakerDisabled,
    Layout? layoutType,
    String? rid,
    String? sid,
    String? mode,
    bool? isRecording,
  }) {
    return AgoraSettings(
      engine: engine ?? this.engine,
      connectionData: connectionData ?? this.connectionData,
      users: users ?? this.users,
      mainAgoraUser: mainAgoraUser ?? this.mainAgoraUser,
      isLocalUserMuted: isLocalUserMuted ?? this.isLocalUserMuted,
      isLocalVideoDisabled: isLocalVideoDisabled ?? this.isLocalVideoDisabled,
      visible: visible ?? this.visible,
      clientRole: clientRole ?? this.clientRole,
      localUid: localUid ?? this.localUid,
      generatedToken: generatedToken ?? this.generatedToken,
      isActiveSpeakerDisabled:
          isActiveSpeakerDisabled ?? this.isActiveSpeakerDisabled,
      layoutType: layoutType ?? this.layoutType,
      rid: rid ?? this.rid,
      sid: sid ?? this.sid,
      mode: mode ?? this.mode,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
