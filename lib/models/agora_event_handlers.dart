import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraEventHandlers {
  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] joins the channel
  Function(int uid, int elapsed)? userJoined;

  /// Occurs when the local user joins a specified channel.
  Function(String channel, int uid, int elapsed)? joinChannelSuccess;

  /// Reports an error during SDK runtime
  Function(ErrorCode errorCode)? onError;

  /// Occurs when a user leaves the channel.
  Function(RtcStats stats)? leaveChannel;

  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] leaves the channel.
  Function(int uid, UserOfflineReason reason)? userOffline;

  /// Occurs when the token expires in 30 seconds.
  Function(String token)? tokenPrivilegeWillExpire;

  /// Occurs when the remote video state changes.
  Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
      int elapsed)? remoteVideoStateChanged;

  /// Occurs when the remote audio state changes.
  Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
      int elapsed)? remoteAudioStateChanged;

  /// Occurs when the local audio state changes.
  Function(AudioLocalState state, AudioLocalError error)?
      localAudioStateChanged;

  /// Occurs when the local video state changes.
  Function(LocalVideoStreamState localVideoState, LocalVideoStreamError error)?
      localVideoStateChanged;

  /// Reports which user is the loudest speaker.
  Function(int uid)? activeSpeaker;

  AgoraEventHandlers({
    this.userJoined,
    this.joinChannelSuccess,
    this.onError,
    this.activeSpeaker,
    this.leaveChannel,
    this.localAudioStateChanged,
    this.localVideoStateChanged,
    this.remoteAudioStateChanged,
    this.remoteVideoStateChanged,
    this.tokenPrivilegeWillExpire,
    this.userOffline,
  });

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
