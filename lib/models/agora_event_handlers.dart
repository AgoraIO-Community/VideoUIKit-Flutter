import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraEventHandlers {
  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] joins the channel
  final Function(int uid, int elapsed) userJoined;

  /// Occurs when the local user joins a specified channel.
  final Function(String channel, int uid, int elapsed) joinChannelSuccess;

  /// Reports an error during SDK runtime
  final Function(ErrorCode errorCode) onError;

  /// Occurs when a user leaves the channel.
  final Function(RtcStats stats) leaveChannel;

  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] leaves the channel.
  final Function(int uid, UserOfflineReason reason) userOffline;

  /// Occurs when the token expires in 30 seconds.
  final Function(String token) tokenPrivilegeWillExpire;

  /// Occurs when the remote video state changes.
  final Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
      int elapsed) remoteVideoStateChanged;

  /// Occurs when the remote audio state changes.
  final Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
      int elapsed) remoteAudioStateChanged;

  /// Occurs when the local audio state changes.
  final Function(AudioLocalState state, AudioLocalError error)
      localAudioStateChanged;

  /// Occurs when the local video state changes.
  final Function(
          LocalVideoStreamState localVideoState, LocalVideoStreamError error)
      localVideoStateChanged;

  /// Reports which user is the loudest speaker.
  final Function(int uid) activeSpeaker;

  const AgoraEventHandlers({
    required this.userJoined,
    required this.joinChannelSuccess,
    required this.onError,
    required this.activeSpeaker,
    required this.leaveChannel,
    required this.localAudioStateChanged,
    required this.localVideoStateChanged,
    required this.remoteAudioStateChanged,
    required this.remoteVideoStateChanged,
    required this.tokenPrivilegeWillExpire,
    required this.userOffline,
  });

  factory AgoraEventHandlers.empty() => AgoraEventHandlers(
        userJoined: (_, __) {},
        joinChannelSuccess: (_, __, ___) {},
        onError: (_) {},
        activeSpeaker: (_) {},
        leaveChannel: (_) {},
        localAudioStateChanged: (_, __) {},
        localVideoStateChanged: (_, __) {},
        remoteAudioStateChanged: (_, __, ___, ____) {},
        remoteVideoStateChanged: (_, __, ___, ____) {},
        tokenPrivilegeWillExpire: (_) {},
        userOffline: (_, __) {},
      );

  AgoraEventHandlers copyWith({
    Function(int uid, int elapsed)? userJoined,
    Function(String channel, int uid, int elapsed)? joinChannelSuccess,
    Function(ErrorCode errorCode)? onError,
    Function(RtcStats stats)? leaveChannel,
    Function(int uid, UserOfflineReason reason)? userOffline,
    Function(String token)? tokenPrivilegeWillExpire,
    Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
            int elapsed)?
        remoteVideoStateChanged,
    Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
            int elapsed)?
        remoteAudioStateChanged,
    Function(AudioLocalState state, AudioLocalError error)?
        localAudioStateChanged,
    Function(
            LocalVideoStreamState localVideoState, LocalVideoStreamError error)?
        localVideoStateChanged,
    Function(int uid)? activeSpeaker,
  }) {
    return AgoraEventHandlers(
      userJoined: userJoined ?? this.userJoined,
      joinChannelSuccess: joinChannelSuccess ?? this.joinChannelSuccess,
      onError: onError ?? this.onError,
      leaveChannel: leaveChannel ?? this.leaveChannel,
      userOffline: userOffline ?? this.userOffline,
      tokenPrivilegeWillExpire:
          tokenPrivilegeWillExpire ?? this.tokenPrivilegeWillExpire,
      remoteVideoStateChanged:
          remoteVideoStateChanged ?? this.remoteVideoStateChanged,
      remoteAudioStateChanged:
          remoteAudioStateChanged ?? this.remoteAudioStateChanged,
      localVideoStateChanged:
          localVideoStateChanged ?? this.localVideoStateChanged,
      localAudioStateChanged:
          localAudioStateChanged ?? this.localAudioStateChanged,
      activeSpeaker: activeSpeaker ?? this.activeSpeaker,
    );
  }
}
