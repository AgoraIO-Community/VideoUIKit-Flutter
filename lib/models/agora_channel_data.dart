import 'package:agora_rtc_engine/agora_rtc_engine.dart';

/// Use this class to define the properties of a channel and the behaviour of a user inside that channel.
class AgoraChannelData {
  /// The Agora [RtcEngine] differentiates channel profiles and applies different optimization algorithms accordingly.
  ///
  /// You can choose between 3 default channel profiles [ChannelProfileType.channelProfileCommunication], [ChannelProfileType.channelProfileLiveBroadcasting], [ChannelProfileType.channelProfileCommunication1v1], [ChannelProfileType.channelProfileCloudGaming] and [ChannelProfileType.channelProfileGame]
  final ChannelProfileType channelProfileType;

  /// Sets the role of a user in a live interactive streaming.
  /// This method applies only when [channelProfileType] is set to [ChannelProfileType.channelProfileLiveBroadcasting]
  ///
  /// Use this to set the user behaviour inside a channel. A user can choose between a [ClientRoleType.clientRoleAudience] or [ClientRoleType.clientRoleBroadcaster].
  /// - An audience member can only receive the stream.
  /// - A broadcaster can send and receive the stream.
  ClientRoleType clientRoleType;

  /// Each video encoder configuration corresponds to a set of video parameters, including the resolution, frame rate, bitrate, and video orientation.
  ///
  /// The parameters specified in this method are the maximum values under ideal network conditions. If the video engine cannot render the video using the specified parameters due to poor network conditions, the parameters further down the list are considered until a successful configuration is found.
  VideoEncoderConfiguration? videoEncoderConfiguration;

  /// Enables the camera auto-face focus function.
  ///
  /// *Parameter* Sets whether to enable/disable the camera auto-face focus function:
  /// - `true`: Enable the camera auto-face focus function.
  /// - `false`: (Default) Disable the camera auto-face focus function.
  bool setCameraAutoFocusFaceModeEnabled;

  /// Enables/Disables the dual video stream mode.
  ///
  /// If dual-stream mode is enabled, the receiver can choose to receive the high stream (high-resolution high-bitrate video stream) or low stream (low-resolution low-bitrate video stream) video.
  ///
  /// *Parameter* Sets the stream mode:
  /// - `true`: Dual-stream mode.
  /// - `false`: (Default) Single-stream mode.
  bool enableDualStreamMode;

  /// Sets the fallback option for the locally published video stream based on the network conditions.
  ///
  /// Note: Agora does not recommend using this method for CDN live streaming, because the remote CDN live user will have a noticeable lag when the locally published video stream falls back to audio only.
  /// *Parameter* StreamFallbackOptions
  /// - [StreamFallbackOptions.AudioOnly]: Under unreliable uplink network conditions, the published video stream falls back to audio only. Under unreliable downlink network conditions, the remote video stream first falls back to the low-stream (low resolution and low bitrate) video; and then to an audio-only stream if the network condition deteriorates.
  /// - [StreamFallbackOptions.Disabled]: No fallback behavior for the local/remote video stream when the uplink/downlink network condition is unreliable. The quality of the stream is not guaranteed.
  /// - [StreamFallbackOptions.VideoStreamLow]: Under unreliable downlink network conditions, the remote video stream falls back to the low-stream (low resolution and low bitrate) video. You can only set this option in the [remoteSubscribeFallbackOption] method. Nothing happens when you set this in the [localPublishFallbackOption] method.
  StreamFallbackOptions? localPublishFallbackOption;

  /// Sets the fallback option for the remotely subscribed video stream based on the network conditions.
  ///
  /// If option is set as StreamFallbackOptions.VideoStreamLow or StreamFallbackOptions.AudioOnly, the SDK automatically switches the video from a high-stream to a low-stream, or disables the video when the downlink network condition cannot support both audio and video to guarantee the quality of the audio. The SDK monitors the network quality and restores the video stream when the network conditions improve.
  ///
  /// *Parameter* StreamFallbackOptions
  /// - [StreamFallbackOptions.AudioOnly]: Under unreliable uplink network conditions, the published video stream falls back to audio only. Under unreliable downlink network conditions, the remote video stream first falls back to the low-stream (low resolution and low bitrate) video; and then to an audio-only stream if the network condition deteriorates.
  /// - [StreamFallbackOptions.Disabled]: No fallback behavior for the local/remote video stream when the uplink/downlink network condition is unreliable. The quality of the stream is not guaranteed.
  /// - [StreamFallbackOptions.VideoStreamLow]: Under unreliable downlink network conditions, the remote video stream falls back to the low-stream (low resolution and low bitrate) video. You can only set this option in the [remoteSubscribeFallbackOption] method. Nothing happens when you set this in the [localPublishFallbackOption] method.
  StreamFallbackOptions? remoteSubscribeFallbackOption;

  /// Sets the audio parameters and application scenarios.
  ///
  /// Sets the sample rate, bitrate, encoding mode, and the number of channels.
  ///
  /// To know more about AudioProfile have a look over here [AudioProfile]
  AudioProfileType audioProfileType;

  /// Sets the audio parameters and application scenarios.
  ///
  /// Sets the audio application scenarios. Under different audio scenarios, the device uses different volume tracks, i.e. either the in-call volume or the media volume. S
  /// To know more about AudioScenario have a look over here [AudioScenario]
  AudioScenarioType audioScenarioType;

  /// Enhancess the image being streamed on the channel.
  ///
  /// Sets the image enhancement options.
  ///
  /// To know more about BeautyOptions have a look over here [BeautyOptions]
  BeautyOptions? setBeautyEffectOptions;

  /// Enables the camera flash function.
  ///
  /// *Parameter* Enables the camera flash:
  /// - `true`: Enable the camera flash function.
  /// - `false`: (Default) Disable the camera flash function.
  bool setCameraTorchOn;

  /// Stops/Resumes receiving all remote audio streams.
  ///
  /// *Parameter* Determines whether to receive/stop receiving all remote audio streams:
  /// - `true`: Stop receiving all remote audio streams.
  /// - `false`: (Default) Receive all remote audio streams.
  bool muteAllRemoteVideoStreams;

  /// Stops/Resumes receiving all remote video streams.
  ///
  /// *Parameter* Determines whether to receive/stop receiving all remote audio streams:
  /// - `true`: Stop receiving all remote video streams.
  /// - `false`: (Default) Receive all remote video streams.
  bool muteAllRemoteAudioStreams;

  /// Active Speaker method automatically pins the active speaker to the main view. By default active speaker is enabled.
  ///
  /// *Parameter* Determines whether to disable/enable active speaker:
  /// - `true`: Set it to true to disable active speaker.
  /// - `false`: (Default) Active speaker is enabled by default.
  final bool isActiveSpeakerDisabled;

  AgoraChannelData({
    this.channelProfileType = ChannelProfileType.channelProfileCommunication,
    this.clientRoleType = ClientRoleType.clientRoleBroadcaster,
    this.videoEncoderConfiguration,
    this.setCameraAutoFocusFaceModeEnabled = false,
    this.enableDualStreamMode = false,
    this.localPublishFallbackOption,
    this.remoteSubscribeFallbackOption,
    this.audioProfileType = AudioProfileType.audioProfileDefault,
    this.audioScenarioType = AudioScenarioType.audioScenarioDefault,
    this.setBeautyEffectOptions,
    this.setCameraTorchOn = false,
    this.muteAllRemoteAudioStreams = false,
    this.muteAllRemoteVideoStreams = false,
    this.isActiveSpeakerDisabled = false,
  });

  AgoraChannelData copyWith({
    final ChannelProfileType? channelProfileType,
    ClientRoleType? clientRoleType,
    VideoEncoderConfiguration? videoEncoderConfiguration,
    bool? setCameraAutoFocusFaceModeEnabled,
    bool? enableDualStreamMode,
    StreamFallbackOptions? localPublishFallbackOption,
    StreamFallbackOptions? remoteSubscribeFallbackOption,
    AudioProfileType? audioProfileType,
    AudioScenarioType? audioScenarioType,
    BeautyOptions? setBeautyEffectOptions,
    bool? setCameraTorchOn,
    bool? muteAllRemoteVideoStreams,
    bool? muteAllRemoteAudioStreams,
    bool? isActiveSpeakerDisabled,
  }) {
    return AgoraChannelData(
      channelProfileType: channelProfileType ?? this.channelProfileType,
      clientRoleType: clientRoleType ?? this.clientRoleType,
      videoEncoderConfiguration:
          videoEncoderConfiguration ?? this.videoEncoderConfiguration,
      setCameraAutoFocusFaceModeEnabled: setCameraAutoFocusFaceModeEnabled ??
          this.setCameraAutoFocusFaceModeEnabled,
      enableDualStreamMode: enableDualStreamMode ?? this.enableDualStreamMode,
      localPublishFallbackOption:
          localPublishFallbackOption ?? this.localPublishFallbackOption,
      remoteSubscribeFallbackOption:
          remoteSubscribeFallbackOption ?? this.remoteSubscribeFallbackOption,
      audioProfileType: audioProfileType ?? this.audioProfileType,
      audioScenarioType: audioScenarioType ?? this.audioScenarioType,
      setBeautyEffectOptions:
          setBeautyEffectOptions ?? this.setBeautyEffectOptions,
      setCameraTorchOn: setCameraTorchOn ?? this.setCameraTorchOn,
      muteAllRemoteAudioStreams:
          muteAllRemoteAudioStreams ?? this.muteAllRemoteAudioStreams,
      muteAllRemoteVideoStreams:
          muteAllRemoteVideoStreams ?? this.muteAllRemoteVideoStreams,
      isActiveSpeakerDisabled:
          isActiveSpeakerDisabled ?? this.isActiveSpeakerDisabled,
    );
  }
}
