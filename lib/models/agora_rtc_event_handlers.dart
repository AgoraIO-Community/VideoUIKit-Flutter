import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraRtcEventHandlers {
  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] joins the channel
  final Function(int uid, int elapsed)? userJoined;

  /// Occurs when the local user joins a specified channel.
  final Function(String channel, int uid, int elapsed)? joinChannelSuccess;

  /// Reports an error during SDK runtime
  final Function(ErrorCode errorCode)? onError;

  /// Occurs when a user leaves the channel.
  final Function(RtcStats stats)? leaveChannel;

  /// Occurs when a remote user [ChannelProfile.Communication]/host [ChannelProfile.LiveBroadcasting] leaves the channel.
  final Function(int uid, UserOfflineReason reason)? userOffline;

  /// Occurs when the token expires in 30 seconds.
  final Function(String token)? tokenPrivilegeWillExpire;

  /// Occurs when the remote video state changes.
  final Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
      int elapsed)? remoteVideoStateChanged;

  /// Occurs when the remote audio state changes.
  final Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
      int elapsed)? remoteAudioStateChanged;

  /// Occurs when the local audio state changes.
  final Function(AudioLocalState state, AudioLocalError error)?
      localAudioStateChanged;

  /// Occurs when the local video state changes.
  final Function(
          LocalVideoStreamState localVideoState, LocalVideoStreamError error)?
      localVideoStateChanged;

  /// Reports which user is the loudest speaker.
  final Function(int uid)? activeSpeaker;

  /// Reports a warning during SDK runtime.
  final Function(WarningCode)? warning;

  /// Occurs when an API method is executed.
  final Function(ErrorCode, String, String)? apiCallExecuted;

  /// Occurs when a user rejoins the channel after being disconnected due to network problems.
  final Function(String, int, int)? rejoinChannelSuccess;

  /// Occurs when the local user registers a user account.
  final Function(int, String)? localUserRegistered;

  /// Occurs when the SDK gets the user ID and user account of the remote user.
  final Function(int, UserInfo)? userInfoUpdated;

  /// Occurs when the user role switches in a live broadcast. For example, from a host to an audience or from an audience to a host.
  final Function(ClientRole, ClientRole)? clientRoleChanged;

  /// Occurs when the network connection state changes.
  final Function(ConnectionStateType, ConnectionChangedReason)?
      connectionStateChanged;

  /// Occurs when the network type changes.
  final Function(NetworkType)? networkTypeChanged;

  /// Occurs when the SDK cannot reconnect to Agora's edge server 10 seconds after its connection to the server is interrupted.
  final Function()? connectionLost;

  /// Occurs when the token has expired.
  final Function()? requestToken;

  /// Reports which users are speaking and the speakers' volume, and whether the local user is speaking.
  final Function(List<AudioVolumeInfo>, int)? audioVolumeIndication;

  /// Occurs when the first local audio frame is sent.
  final Function(int)? firstLocalAudioFrame;

  /// Occurs when the first local video frame is rendered.
  final Function(int, int, int)? firstLocalVideoFrame;

  /// Occurs when a remote user stops/resumes sending the video stream.
  final Function(int, bool)? userMuteVideo;

  /// Occurs when the video size or rotation information of a remote user changes.
  final Function(int, int, int, int)? videoSizeChanged;

  /// Occurs when the published media stream falls back to an audio-only stream due to poor network conditions or switches back to video stream after the network conditions improve.
  final Function(bool)? localPublishFallbackToAudioOnly;

  /// Occurs when the remote media stream falls back to audio-only stream due to poor network conditions or switches back to video stream after the network conditions improve.
  final Function(int, bool)? remoteSubscribeFallbackToAudioOnly;

  /// Occurs when the local audio playback route changes.
  final Function(AudioOutputRouting)? audioRouteChanged;

  /// Occurs when the camera focus area is changed.
  final Function(Rect)? cameraFocusAreaChanged;

  /// The camera exposure area has changed.
  final Function(Rect)? cameraExposureAreaChanged;

  /// Reports the face detection result of the local user.
  final Function(int, int, List<FacePositionInfo>)? facePositionChanged;

  /// Reports the statistics of the [RtcEngine] once every two seconds.
  final Function(RtcStats)? rtcStats;

  /// Reports the last mile network quality of the local user once every two seconds before the user joins the channel.
  final Function(NetworkQuality)? lastmileQuality;

  /// Reports the last mile network quality of each user in the channel once every two seconds.
  final Function(int, NetworkQuality, NetworkQuality)? networkQuality;

  /// Reports the last-mile network probe result.
  final Function(LastmileProbeResult)? lastmileProbeResult;

  /// Reports the statistics of the local video streams.
  final Function(LocalVideoStats)? localVideoStats;

  /// Reports the statistics of the local audio stream.
  final Function(LocalAudioStats)? localAudioStats;

  /// Reports the statistics of the video stream from each remote user/host.
  final Function(RemoteVideoStats)? remoteVideoStats;

  /// Reports the statistics of the audio stream from each remote user/host.
  final Function(RemoteAudioStats)? remoteAudioStats;

  /// Occurs when the audio mixing file playback finishes.
  final Function()? audioMixingFinished;

  /// Occurs when the playback state of the local user's music file changes.
  final Function(AudioMixingStateCode, AudioMixingReason)?
      audioMixingStateChanged;

  /// Occurs when the audio effect file playback finishes.
  final Function(int)? audioEffectFinished;

  /// Occurs when the state of the RTMP or RTMPS streaming changes.
  final Function(String, RtmpStreamingState, RtmpStreamingErrorCode)?
      rtmpStreamingStateChanged;

  /// Occurs when the publisher's transcoding settings are updated.
  final Function()? transcodingUpdated;

  /// Reports the status of injecting the online media stream.
  final Function(String, int, InjectStreamStatus)? streamInjectedStatus;

  /// Occurs when the local user receives a remote data stream.
  final Function(int, int, Uint8List)? streamMessage;

  /// Occurs when the local user fails to receive a remote data stream.
  final Function(int, int, ErrorCode, int, int)? streamMessageError;

  /// Occurs when the media engine is loaded.
  final Function()? mediaEngineLoadSuccess;

  /// Occurs when the media engine starts.
  final Function()? mediaEngineStartCallSuccess;

  /// Occurs when the state of the media stream relay changes.
  final Function(ChannelMediaRelayState, ChannelMediaRelayError)?
      channelMediaRelayStateChanged;

  /// Reports events during the media stream relay.
  final Function(ChannelMediaRelayEvent)? channelMediaRelayEvent;

  /// Occurs when the local user receives the metadata.
  final Function(Metadata)? metadataReceived;

  /// Occurs when the first video frame is published.
  final Function(int)? firstLocalVideoFramePublished;

  /// Occurs when the first audio frame is published.
  final Function(int)? firstLocalAudioFramePublished;

  /// Occurs when the audio publishing state changes.
  final Function(String, StreamPublishState, StreamPublishState, int)?
      audioPublishStateChanged;

  /// Occurs when the video publishing state changes.
  final Function(String, StreamPublishState, StreamPublishState, int)?
      videoPublishStateChanged;

  /// Occurs when the audio subscribing state changes.
  final Function(String, int, StreamSubscribeState, StreamSubscribeState, int)?
      audioSubscribeStateChanged;

  /// Occurs when the video subscribing state changes.
  final Function(String, int, StreamSubscribeState, StreamSubscribeState, int)?
      videoSubscribeStateChanged;

  /// Reports events during the RTMP or RTMPS streaming.
  final Function(String, RtmpStreamingEvent)? rtmpStreamingEvent;

  /// @nodoc
  final Function(int, bool, SuperResolutionStateReason)?
      userSuperResolutionEnabled;

  /// @nodoc
  final Function(String, bool, UploadErrorReason)? uploadLogResult;

  const AgoraRtcEventHandlers({
    this.warning,
    this.apiCallExecuted,
    this.rejoinChannelSuccess,
    this.localUserRegistered,
    this.userInfoUpdated,
    this.clientRoleChanged,
    this.connectionStateChanged,
    this.networkTypeChanged,
    this.connectionLost,
    this.requestToken,
    this.audioVolumeIndication,
    this.firstLocalAudioFrame,
    this.firstLocalVideoFrame,
    this.userMuteVideo,
    this.videoSizeChanged,
    this.localPublishFallbackToAudioOnly,
    this.remoteSubscribeFallbackToAudioOnly,
    this.audioRouteChanged,
    this.cameraFocusAreaChanged,
    this.cameraExposureAreaChanged,
    this.facePositionChanged,
    this.rtcStats,
    this.lastmileQuality,
    this.networkQuality,
    this.lastmileProbeResult,
    this.localVideoStats,
    this.localAudioStats,
    this.remoteVideoStats,
    this.remoteAudioStats,
    this.audioMixingFinished,
    this.audioMixingStateChanged,
    this.audioEffectFinished,
    this.rtmpStreamingStateChanged,
    this.transcodingUpdated,
    this.streamInjectedStatus,
    this.streamMessage,
    this.streamMessageError,
    this.mediaEngineLoadSuccess,
    this.mediaEngineStartCallSuccess,
    this.channelMediaRelayStateChanged,
    this.channelMediaRelayEvent,
    this.metadataReceived,
    this.firstLocalAudioFramePublished,
    this.firstLocalVideoFramePublished,
    this.audioPublishStateChanged,
    this.videoPublishStateChanged,
    this.audioSubscribeStateChanged,
    this.videoSubscribeStateChanged,
    this.rtmpStreamingEvent,
    this.userSuperResolutionEnabled,
    this.uploadLogResult,
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
}
