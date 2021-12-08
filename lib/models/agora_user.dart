import 'package:agora_rtc_engine/rtc_engine.dart';

/// Data class of a user present in a channel.
class AgoraUser {
  int uid;
  final bool remote;
  final bool muted;
  final bool videoDisabled;
  final ClientRole clientRole;

  AgoraUser({
    required this.uid,
    this.remote = true,
    this.muted = false,
    this.videoDisabled = false,
    this.clientRole = ClientRole.Broadcaster,
  });

  AgoraUser copyWith({
    int? uid,
    bool? remote,
    bool? muted,
    bool? videoDisabled,
    ClientRole? clientRole,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      remote: remote ?? this.remote,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
      clientRole: clientRole ?? this.clientRole,
    );
  }
}
