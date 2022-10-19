import 'package:agora_rtc_engine/agora_rtc_engine.dart';

/// Data class of a user present in a channel.
class AgoraUser {
  int uid;
  final bool remote;
  final bool muted;
  final bool videoDisabled;
  final ClientRoleType clientRoleType;

  AgoraUser({
    required this.uid,
    this.remote = true,
    this.muted = false,
    this.videoDisabled = false,
    this.clientRoleType = ClientRoleType.clientRoleBroadcaster,
  });

  AgoraUser copyWith({
    int? uid,
    bool? remote,
    bool? muted,
    bool? videoDisabled,
    ClientRoleType? clientRoleType,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      remote: remote ?? this.remote,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
      clientRoleType: clientRoleType ?? this.clientRoleType,
    );
  }
}
