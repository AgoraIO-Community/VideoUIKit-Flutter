import 'dart:typed_data';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraRtcEventHandlers {
  /// Occurs when a user joins a channel.
  /// This callback notifies the application that a user joins a specified channel.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [elapsed] The time elapsed (ms) from the local user calling joinChannel [2/2] until the SDK triggers this callback.
  final void Function(RtcConnection connection, int elapsed)?
      onJoinChannelSuccess;

  /// Occurs when a user rejoins the channel.
  /// When a user loses connection with the server because of network problems, the SDK automatically tries to reconnect and triggers this callback upon reconnection.
  ///
  /// * [elapsed] Time elapsed (ms) from the local user calling the joinChannel [1/2] or joinChannel [2/2] method until this callback is triggered.
  final void Function(RtcConnection connection, int elapsed)?
      onRejoinChannelSuccess;

  /// Reports the proxy connection state.
  /// You can use this callback to listen for the state of the SDK connecting to a proxy. For example, when a user calls setCloudProxy and joins a channel successfully, the SDK triggers this callback to report the user ID, the proxy type connected, and the time elapsed fromthe user calling joinChannel [1/2] until this callback is triggered.
  ///
  /// * [channel] The channel name.
  /// * [uid] The user ID.
  ///
  /// * [localProxyIp] Reserved for future use.
  /// * [elapsed] The time elapsed (ms) from the user calling joinChannel [1/2] until this callback is triggered.
  final void Function(String channel, int uid, ProxyType proxyType,
      String localProxyIp, int elapsed)? onProxyConnected;

  /// Reports an error during SDK runtime.
  /// This callback indicates that an error (concerning network or media) occurs during SDK runtime. In most cases, the SDK cannot fix the issue and resume running. The SDK requires the application to take action or informs the user about the issue.
  ///
  /// * [err] Error code. See ErrorCodeType .
  /// * [msg] The error message.
  final void Function(ErrorCodeType err, String msg)? onError;

  /// Reports the statistics of the audio stream from each remote user.
  /// Deprecated:Please use onRemoteAudioStats instead.The SDK triggers this callback once every two seconds to report the audio quality of each remote user/host sending an audio stream. If a channel has multiple users/hosts sending audio streams, the SDK triggers this callback as many times.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID of the remote user sending the audio stream.
  /// * [quality] Audio quality of the user. See QualityType .
  /// * [delay] The network delay (ms) from the sender to the receiver, including the delay caused by audio sampling pre-processing, network transmission, and network jitter buffering.
  /// * [lost] The packet loss rate (%) of the audio packet sent from the remote user.
  final void Function(RtcConnection connection, int remoteUid,
      QualityType quality, int delay, int lost)? onAudioQuality;

  /// Reports the last mile network probe result.
  /// The SDK triggers this callback within 30 seconds after the app calls startLastmileProbeTest .
  ///
  /// * [result] The uplink and downlink last-mile network probe test result. See LastmileProbeResult .
  final void Function(LastmileProbeResult result)? onLastmileProbeResult;

  /// Reports the volume information of users.
  /// By default, this callback is disabled. You can enable it by calling enableAudioVolumeIndication . Once this callback is enabled and users send streams in the channel, the SDK triggers the onAudioVolumeIndication callback according to the time interval set in enableAudioVolumeIndication. The SDK triggers two independent onAudioVolumeIndication callbacks simultaneously, which separately report the volume information of the local user who sends a stream and the remote users (up to three) whose instantaneous volume is the highest.Once this callback is enabled, if the local user calls the muteLocalAudioStream method for mute, the SDK continues to report the volume indication of the local user.20 seconds after a remote user whose volume is one of the three highest in the channel stops publishing the audio stream, the callback excludes this user's information; 20 seconds after all remote users stop publishing audio streams, the SDK stops triggering the callback for remote users.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [speakers] The volume information of the users. See AudioVolumeInfo . An empty speakers array in the callback indicates that no remote user is in the channel or sending a stream at the moment.
  /// * [speakerNumber] The total number of users.In the callback for the local user, if the local user is sending streams, the value of speakerNumber is 1.In the callback for remote users, the value range of speakerNumber is [0,3]. If the number of remote users who send streams is greater than or equal to three, the value of speakerNumber is 3.
  /// * [totalVolume] The volume of the speaker. The value ranges between 0 (lowest volume) and 255 (highest volume).In the callback for the local user, totalVolume is the volume of the local user who sends a stream.In the callback for remote users, totalVolume is the sum of the volume of the remote users (up to three) whose instantaneous volume are the highest.
  final void Function(RtcConnection connection, List<AudioVolumeInfo> speakers,
      int speakerNumber, int totalVolume)? onAudioVolumeIndication;

  /// Occurs when a user leaves a channel.
  /// This callback notifies the app that the user leaves the channel by calling leaveChannel . From this callback, the app can get information such as the call duration and quality statistics.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [stats] The statistics of the call. See RtcStats .
  final void Function(RtcConnection connection, RtcStats stats)? onLeaveChannel;

  /// Reports the statistics of the current call.
  /// The SDK triggers this callback once every two seconds after the user joins the channel.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [stats] Statistics of the RTC engine. See RtcStats .
  ///
  final void Function(RtcConnection connection, RtcStats stats)? onRtcStats;

  /// Occurs when the audio device state changes.
  /// This callback notifies the application that the system's audio device state is changed. For example, a headset is unplugged from the device.This method is for Windows and macOS only.
  ///
  /// * [deviceId] The device ID.
  /// * [deviceType] The evice type. See MediaDeviceType .
  /// * [deviceState] The device state.On macOS:0: The device is ready for use.8: The device is not connected.On Windows: see MediaDeviceStateType .
  final void Function(String deviceId, MediaDeviceType deviceType,
      MediaDeviceStateType deviceState)? onAudioDeviceStateChanged;

  /// Occurs when the playback of the local music file finishes.
  /// Deprecated:Please use onAudioMixingStateChanged instead.After you call startAudioMixing to play a local music file, this callback occurs when the playback finishes. If the call startAudioMixing fails, the error code WARN_AUDIO_MIXING_OPEN_ERROR is returned.
  final void Function()? onAudioMixingFinished;

  /// Occurs when the playback of the local music file finishes.
  /// This callback occurs when the local audio effect file finishes playing.
  ///
  /// * [soundId] The audio effect ID. The ID of each audio effect file is unique.
  final void Function(int soundId)? onAudioEffectFinished;

  /// @nodoc
  final void Function(String deviceId, MediaDeviceType deviceType,
      MediaDeviceStateType deviceState)? onVideoDeviceStateChanged;

  /// Reports the last mile network quality of each user in the channel.
  /// This callback reports the last mile network conditions of each user in the channel. Last mile refers to the connection between the local device and Agora's edge server.The SDK triggers this callback once every two seconds. If a channel includes multiple users, the SDK triggers this callback as many times.txQuality is rxQuality is
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID. The network quality of the user with this user ID is reported.
  /// * [txQuality] Uplink network quality rating of the user in terms of the transmission bit rate, packet loss rate, average RTT (Round-Trip Time) and jitter of the uplink network. This parameter is a quality rating helping you understand how well the current uplink network conditions can support the selected video encoder configuration. For example, a 1000 Kbps uplink network may be adequate for video frames with a resolution of 640 × 480 and a frame rate of 15 fps in the LIVE_BROADCASTING profile, but may be inadequate for resolutions higher than 1280 × 720. See QualityType .
  /// * [rxQuality] Downlink network quality rating of the user in terms of packet loss rate, average RTT, and jitter of the downlink network. See QualityType .
  final void Function(RtcConnection connection, int remoteUid,
      QualityType txQuality, QualityType rxQuality)? onNetworkQuality;

  /// @nodoc
  final void Function(RtcConnection connection)? onIntraRequestReceived;

  /// Occurs when the uplink network information changes.
  /// The SDK triggers this callback when the uplink network information changes.This callback only applies to scenarios where you push externally encoded video data in H.264 format to the SDK.
  ///
  /// * [info] The uplink network information. See UplinkNetworkInfo .
  final void Function(UplinkNetworkInfo info)? onUplinkNetworkInfoUpdated;

  /// @nodoc
  final void Function(DownlinkNetworkInfo info)? onDownlinkNetworkInfoUpdated;

  /// Reports the last-mile network quality of the local user.
  /// This callback reports the last-mile network conditions of the local user before the user joins the channel. Last mile refers to the connection between the local device and Agora's edge server.Before the user joins the channel, this callback is triggered by the SDK once startLastmileProbeTest is called and reports the last-mile network conditions of the local user.
  ///
  /// * [quality] The last-mile network quality.
  ///  qualityUnknown(0): The quality is unknown.
  ///  qualityExcellent(1): The quality is excellent.
  ///  qualityGood(2): The network quality seems excellent, but the bitrate can be slightly lower than excellent.
  ///  qualityPoor(3): Users can feel the communication is slightly impaired.
  ///  qualityBad(4): Users cannot communicate smoothly.
  ///  qualityVbad(5): The quality is so bad that users can barely communicate.
  ///  qualityDown(6): The network is down, and users cannot communicate at all.
  ///  See QualityType .
  final void Function(QualityType quality)? onLastmileQuality;

  /// Occurs when the first local video frame is displayed on the local video view.
  /// The SDK triggers this callback when the first local video frame is displayed on the local video view.
  ///
  /// * [source] The type of the video source. See VideoSourceType .
  /// * [width] The width (px) of the first local video frame.
  /// * [height] The height (px) of the first local video frame.
  /// * [elapsed] Time elapsed (ms) from the local user calling joinChannel until the SDK triggers this callback. If you call startPreview before calling joinChannel, then this parameter is the time elapsed from calling the startPreview method until the SDK triggers this callback.
  final void Function(
          VideoSourceType source, int width, int height, int elapsed)?
      onFirstLocalVideoFrame;

  /// Occurs when the first video frame is published.
  /// The SDK triggers this callback under one of the following circumstances: The local client enables the video module and calls joinChannel successfully. The local client calls muteLocalVideoStream (true) and muteLocalVideoStream (false) in sequence. The local client calls disableVideo and enableVideo in sequence.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [elapsed] Time elapsed (ms) from the local user calling joinChannel [2/2] until the SDK triggers this callback.
  final void Function(VideoSourceType source, int elapsed)?
      onFirstLocalVideoFramePublished;

  /// Occurs when the first remote video frame is received and decoded.
  /// The SDK triggers this callback under one of the following circumstances:The remote user joins the channel and sends the video stream.The remote user stops sending the video stream and re-sends it after 15 seconds. Reasons for such an interruption include:The remote user leaves the channel.The remote user drops offline.The remote user calls muteLocalVideoStream to stop sending the video stream.The remote user calls disableVideo to disable video.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user sending the video stream.
  /// * [width] The width (px) of the video stream.
  /// * [height] The height (px) of the video stream.
  /// * [elapsed] The time elapsed (ms) from the local user calling joinChannel [2/2] until the SDK triggers this callback.
  final void Function(RtcConnection connection, int remoteUid, int width,
      int height, int elapsed)? onFirstRemoteVideoDecoded;

  /// Occurs when the video size or rotation of a specified user changes.
  ///
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [sourceType] The capture type of the custom video source. See VideoSourceType .
  /// * [uid] The ID of the user whose video size or rotation changes. (The uid for the local user is 0. The video is the local user's video preview).
  /// * [width] The width (pixels) of the video stream.
  /// * [height] The height (pixels) of the video stream.
  /// * [rotation] The rotation information. The value range is [0,360).
  final void Function(RtcConnection connection, VideoSourceType sourceType,
      int uid, int width, int height, int rotation)? onVideoSizeChanged;

  /// Occurs when the local video stream state changes.
  /// When the state of the local video stream changes (including the state of the video capture and encoding), the SDK triggers this callback to report the current state. This callback indicates the state of the local video stream, including camera capturing and video encoding, and allows you to troubleshoot issues when exceptions occur.The SDK triggers the onLocalVideoStateChanged callback with the state code of localVideoStreamStateFailed and error code of localVideoStreamErrorCaptureFailure in the following situations:The app switches to the background, and the system gets the camera resource.The camera starts normally, but does not output video frames for four consecutive seconds.When the camera outputs the captured video frames, if the video frames are the same for 15 consecutive frames, the SDK triggers the onLocalVideoStateChanged callback with the state code of localVideoStreamStateCapturing and error code of localVideoStreamErrorCaptureFailure. Note that the video frame duplication detection is only available for video frames with a resolution greater than 200 × 200, a frame rate greater than or equal to 10 fps, and a bitrate less than 20 Kbps.For some device models, the SDK does not trigger this callback when the state of the local video changes while the local video capturing device is in use, so you have to make your own timeout judgment.
  ///
  /// * [source] The capture type of the custom video source. See VideoSourceType .
  /// * [state] The state of the local video, see LocalVideoStreamState .
  /// * [error] The detailed error information, see LocalVideoStreamError .
  final void Function(VideoSourceType source, LocalVideoStreamState state,
      LocalVideoStreamError error)? onLocalVideoStateChanged;

  /// Occurs when the remote video stream state changes.
  /// This callback does not work properly when the number of users (in the communication profile) or hosts (in the live streaming channel) in a channel exceeds 17.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user whose video state changes.
  /// * [state] The state of the remote video, see RemoteVideoState .
  /// * [reason] The reason for the remote video state change, see RemoteVideoStateReason .
  /// * [elapsed] Time elapsed (ms) from the local user calling the joinChannel [2/2] method until the SDK triggers this callback.
  final void Function(
      RtcConnection connection,
      int remoteUid,
      RemoteVideoState state,
      RemoteVideoStateReason reason,
      int elapsed)? onRemoteVideoStateChanged;

  /// Occurs when the renderer receives the first frame of the remote video.
  ///
  ///
  /// * [uid] The ID of the remote user sending the video stream.
  /// * [connection] The connection information. See RtcConnection .
  /// * [width] The width (px) of the video stream.
  /// * [height] The height (px) of the video stream.
  /// * [elapsed] The time elapsed (ms) from the local user calling joinChannel [2/2] until the SDK triggers this callback.
  final void Function(RtcConnection connection, int remoteUid, int width,
      int height, int elapsed)? onFirstRemoteVideoFrame;

  /// Occurs when a remote user (COMMUNICATION)/ host (LIVE_BROADCASTING) joins the channel.
  /// In a communication channel, this callback indicates that a remote user joins the channel. The SDK also triggers this callback to report the existing users in the channel when a user joins the channel.In a live-broadcast channel, this callback indicates that a host joins the channel. The SDK also triggers this callback to report the existing hosts in the channel when a host joins the channel. Agora recommends limiting the number of hosts to 17.The SDK triggers this callback under one of the following circumstances:A remote user/host joins the channel by calling the joinChannel [2/2] method.A remote user switches the user role to the host after joining the channel.A remote user/host rejoins the channel after a network interruption.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the user or host who joins the channel.
  /// * [elapsed] Time delay (ms) from the local user calling joinChannel [2/2] until this callback is triggered.
  final void Function(RtcConnection connection, int remoteUid, int elapsed)?
      onUserJoined;

  /// Occurs when a remote user (in the communication profile)/ host (in the live streaming profile) leaves the channel.
  /// There are two reasons for users to become offline:Leave the channel: When a user/host leaves the channel, the user/host sends a goodbye message. When this message is received, the SDK determines that the user/host leaves the channel.Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the communication profile, and more for the live broadcast profile), the SDK assumes that the user/host drops offline. A poor network connection may lead to false detections. It's recommended to use the Agora RTM SDK for reliable offline detection.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the user who leaves the channel or goes offline.
  /// * [reason] Reasons why the user goes offline: UserOfflineReasonType .
  final void Function(RtcConnection connection, int remoteUid,
      UserOfflineReasonType reason)? onUserOffline;

  /// Occurs when a remote user (in the communication profile) or a host (in the live streaming profile) stops/resumes sending the audio stream.
  /// The SDK triggers this callback when the remote user stops or resumes sending the audio stream by calling the muteLocalAudioStream method.This callback does not work properly when the number of users (in the communication profile) or hosts (in the live streaming channel) in a channel exceeds 17.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID.
  /// * [muted] Whether the remote user's audio stream is muted/unmuted:true: User's audio stream is muted.false: User's audio stream is unmuted.
  final void Function(RtcConnection connection, int remoteUid, bool muted)?
      onUserMuteAudio;

  /// Occurs when a remote user stops/resumes publishing the video stream.
  /// When a remote user calls muteLocalVideoStream to stop or resume publishing the video stream, the SDK triggers this callback to report the state of the remote user's publishing stream to the local user.This callback can be inaccurate when the number of users (in the communication profile) or hosts (in the live streaming profile) in a channel exceeds 17.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID of the remote user.
  /// * [muted] Whether the remote user stops publishing the video stream:true: The remote user stops publishing the video stream.false: The remote user resumes publishing the video stream.
  final void Function(RtcConnection connection, int remoteUid, bool muted)?
      onUserMuteVideo;

  /// Occurs when a remote user enables/disables the video module.
  /// Once the video module is disabled, the user can only use a voice call. The user cannot send or receive any video.The SDK triggers this callback when a remote user enables or disables the video module by calling the enableVideo or disableVideo method.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID of the remote user.
  /// * [enabled] true: Enable.false: Disable.
  final void Function(RtcConnection connection, int remoteUid, bool enabled)?
      onUserEnableVideo;

  /// @nodoc
  final void Function(RtcConnection connection, int remoteUid, int state)?
      onUserStateChanged;

  /// Occurs when a specific remote user enables/disables the local video capturing function.
  /// The SDK triggers this callback when the remote user resumes or stops capturing the video stream by calling the enableLocalVideo method.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The user ID of the remote user.
  /// * [enabled] Whether the specified remote user enables/disables the local video capturing function:true: Enable. Other users in the channel can see the video of this remote user.false: Disable. Other users in the channel can no longer receive the video stream from this remote user, while this remote user can still receive the video streams from other users.
  final void Function(RtcConnection connection, int remoteUid, bool enabled)?
      onUserEnableLocalVideo;

  /// Reports the statistics of the local audio stream.
  /// The SDK triggers this callback once every two seconds.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [stats] Local audio statistics. See LocalAudioStats .
  final void Function(RtcConnection connection, LocalAudioStats stats)?
      onLocalAudioStats;

  /// Reports the statistics of the audio stream sent by each remote users.
  /// The SDK triggers this callback once every two seconds. If a channel includes multiple users, the SDK triggers this callback as many times.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [stats] Statistics of the received remote audio stream. See RemoteAudioStats .
  final void Function(RtcConnection connection, RemoteAudioStats stats)?
      onRemoteAudioStats;

  /// Reports the statistics of the local video stream.
  /// The SDK triggers this callback once every two seconds to report the statistics of the local video stream.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [stats] The statistics of the local video stream. See LocalVideoStats .
  final void Function(VideoSourceType source, LocalVideoStats stats)?
      onLocalVideoStats;

  /// Reports the statistics of the video stream sent by each remote users.
  /// Reports the statistics of the video stream from the remote users. The SDK triggers this callback once every two seconds for each remote user. If a channel has multiple users/hosts sending video streams, the SDK triggers this callback as many times.
  ///
  /// * [stats] Statistics of the remote video stream.
  final void Function(RtcConnection connection, RemoteVideoStats stats)?
      onRemoteVideoStats;

  /// Occurs when the camera turns on and is ready to capture the video.
  /// Deprecated:Please use localVideoStreamStateCapturing(1) in onLocalVideoStateChanged instead.This callback indicates that the camera has been successfully turned on and you can start to capture video.
  final void Function()? onCameraReady;

  /// Occurs when the camera focus area changes.
  ///
  ///
  /// * [x] The x-coordinate of the changed focus area.
  /// * [y] The y-coordinate of the changed focus area.
  /// * [width] The width of the focus area that changes.
  /// * [height] The height of the focus area that changes.
  final void Function(int x, int y, int width, int height)?
      onCameraFocusAreaChanged;

  /// Occurs when the camera exposure area changes.
  ///
  final void Function(int x, int y, int width, int height)?
      onCameraExposureAreaChanged;

  /// Reports the face detection result of the local user.
  /// Once you enable face detection by calling enableFaceDetection (true), you can get the following information on the local user in real-time:The width and height of the local video.The position of the human face in the local view.The distance between the human face and the screen.This value is based on the fitting calculation of the local video size and the position of the human face.This callback is for Android and iOS only.When it is detected that the face in front of the camera disappears, the callback will be triggered immediately. When no human face is detected, the frequency of this callback to be rtriggered wil be decreased to reduce power consumption on the local device.The SDK stops triggering this callback when a human face is in close proximity to the screen.On Android, the value of distance reported in this callback may be slightly different from the actual distance. Therefore, Agora does not recommend using it for accurate calculation.
  ///
  /// * [imageWidth] The width (px) of the video image captured by the local camera.
  /// * [imageHeight] The height (px) of the video image captured by the local camera.
  /// * [vecRectangle] The information of the detected human face. See Rectangle .
  /// * [vecDistance] The distance between the human face and the device screen (cm).
  /// * [numFaces] The number of faces detected. If the value is 0, it means that no human face is detected.
  final void Function(
      int imageWidth,
      int imageHeight,
      List<Rectangle> vecRectangle,
      List<int> vecDistance,
      int numFaces)? onFacePositionChanged;

  /// Occurs when the video stops playing.
  /// Deprecated:Use localVideoStreamStateStopped(0) in the onLocalVideoStateChanged callback instead.The application can use this callback to change the configuration of the view (for example, displaying other pictures in the view) after the video stops playing.
  final void Function()? onVideoStopped;

  /// Occurs when the playback state of the music file changes.
  /// This callback occurs when the playback state of the music file changes, and reports the current state and error code.
  ///
  /// * [state] The playback state of the music file. See AudioMixingStateType .
  /// * [reason] Error code. See AudioMixingReasonType .
  final void Function(AudioMixingStateType state, AudioMixingReasonType reason)?
      onAudioMixingStateChanged;

  /// @nodoc
  final void Function(
          RhythmPlayerStateType state, RhythmPlayerErrorType errorCode)?
      onRhythmPlayerStateChanged;

  /// Occurs when the SDK cannot reconnect to Agora's edge server 10 seconds after its connection to the server is interrupted.
  /// The SDK triggers this callback when it cannot connect to the server 10 seconds after calling the joinChannel [2/2] method, regardless of whether it is in the channel. If the SDK fails to rejoin the channel within 20 minutes after disconnecting, the SDK will stop trying to reconnect.
  ///
  /// * [connection] The connection information. See RtcConnection .
  final void Function(RtcConnection connection)? onConnectionLost;

  /// Occurs when the connection between the SDK and the server is interrupted.
  /// Deprecated:Use onConnectionStateChanged instead.The SDK triggers this callback when it loses connection with the server for more than four seconds after the connection is established. After triggering this callback, the SDK tries to reconnect to the server. You can use this callback to implement pop-up reminders. The difference between this callback and onConnectionLost is:The SDK triggers the onConnectionInterrupted callback when it loses connection with the server for more than four seconds after it successfully joins the channel.The SDK triggers the onConnectionLost callback when it loses connection with the server for more than 10 seconds, whether or not it joins the channel.If the SDK fails to rejoin the channel 20 minutes after being disconnected from Agora's edge server, the SDK stops rejoining the channel.
  ///
  /// * [connection] The connection information. See RtcConnection .
  final void Function(RtcConnection connection)? onConnectionInterrupted;

  /// Occurs when the connection is banned by the Agora server.
  /// Deprecated:Please use onConnectionStateChanged instead.
  ///
  /// * [connection] The connection information. See RtcConnection .
  final void Function(RtcConnection connection)? onConnectionBanned;

  /// Occurs when the local user receives the data stream from the remote user.
  /// The SDK triggers this callback when the local user receives the stream message that the remote user sends by calling the sendStreamMessage method.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [uid] The ID of the remote user sending the message.
  /// * [streamId] The stream ID of the received message.
  /// * [data] received data.
  /// * [length] The data length (byte).
  /// * [sentTs] The time when the data stream is sent.
  final void Function(RtcConnection connection, int remoteUid, int streamId,
      Uint8List data, int length, int sentTs)? onStreamMessage;

  /// Occurs when the local user does not receive the data stream from the remote user.
  /// The SDK triggers this callback when the local user fails to receive the stream message that the remote user sends by calling the sendStreamMessage method.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user sending the message.
  /// * [streamId] The stream ID of the received message.
  /// * [code] The error code.
  /// * [missed] The number of lost messages.
  /// * [cached] Number of incoming cached messages when the data stream is interrupted.
  final void Function(RtcConnection connection, int remoteUid, int streamId,
      ErrorCodeType code, int missed, int cached)? onStreamMessageError;

  /// Occurs when the token expires.
  /// When the token expires during a call, the SDK triggers this callback to remind the app to renew the token.Once you receive this callback, generate a new token on your app server, and call joinChannel [2/2] to rejoin the channel.
  ///
  /// * [connection] The connection information. See RtcConnection .
  final void Function(RtcConnection connection)? onRequestToken;

  /// Occurs when the token expires in 30 seconds.
  /// When the token is about to expire in 30 seconds, the SDK triggers this callback to remind the app to renew the token.Upon receiving this callback, generate a new token on your server, and call renewToken to pass the new token to the SDK.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [token] The token that expires in 30 seconds.
  final void Function(RtcConnection connection, String token)?
      onTokenPrivilegeWillExpire;

  /// Occurs when the first audio frame is published.
  /// The SDK triggers this callback under one of the following circumstances:The local client enables the audio module and calls joinChannel [2/2] successfully.The local client calls muteLocalAudioStream (true) and muteLocalAudioStream(false) in sequence.The local client calls disableAudio and enableAudio in sequence.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [elapsed] Time elapsed (ms) from the local user calling joinChannel [2/2] until the SDK triggers this callback.
  final void Function(RtcConnection connection, int elapsed)?
      onFirstLocalAudioFramePublished;

  /// Occurs when the first audio frame sent by a specified remote user is received.
  /// Deprecated:Use onRemoteAudioStateChanged instead.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [userId] The ID of the remote user sending the audio frames.
  /// * [elapsed] The time elapsed (ms) from the local user calling the joinChannel [2/2] method until the SDK triggers this callback.
  final void Function(RtcConnection connection, int userId, int elapsed)?
      onFirstRemoteAudioFrame;

  /// Occurs when the SDK decodes the first remote audio frame for playback.
  /// Deprecated:Use onRemoteAudioStateChanged instead.The SDK triggers this callback under one of the following circumstances:The remote user joins the channel and sends the audio stream.The remote user stops sending the audio stream and re-sends it after 15 seconds, and the possible reasons include:The remote user leaves the channel.The remote user is offline.The remote user calls muteLocalAudioStream to stop sending the video stream.The remote user calls disableAudio to disable video.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [uid] The user ID of the remote user.
  /// * [elapsed] The time elapsed (ms) from the local user calling the joinChannel [2/2] method until the SDK triggers this callback.
  final void Function(RtcConnection connection, int uid, int elapsed)?
      onFirstRemoteAudioDecoded;

  /// Occurs when the local audio stream state changes.
  /// When the state of the local audio stream changes (including the state of the audio capture and encoding), the SDK triggers this callback to report the current state. This callback indicates the state of the local audio stream, and allows you to troubleshoot issues when audio exceptions occur.When the state is localAudioStreamStateFailed (3), you can view the error information in the error parameter.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [state] The state of the local audio. See localaudiostreamstate .
  /// * [error] Local audio state error codes. See LocalAudioStreamError .
  final void Function(RtcConnection connection, LocalAudioStreamState state,
      LocalAudioStreamError error)? onLocalAudioStateChanged;

  /// Occurs when the remote audio state changes.
  /// When the audio state of a remote user (in a voice/video call channel) or host (in a live streaming channel) changes, the SDK triggers this callback to report the current state of the remote audio stream.This callback does not work properly when the number of users (in the communication profile) or hosts (in the live streaming channel) in a channel exceeds 17.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user whose audio state changes.
  /// * [state] The state of the remote audio. See RemoteAudioState .
  /// * [reason] The reason of the remote audio state change. See RemoteAudioStateReason .
  /// * [elapsed] Time elapsed (ms) from the local user calling the joinChannel [2/2] method until the SDK triggers this callback.
  final void Function(
      RtcConnection connection,
      int remoteUid,
      RemoteAudioState state,
      RemoteAudioStateReason reason,
      int elapsed)? onRemoteAudioStateChanged;

  /// Occurs when the most active remote speaker is detected.
  /// After a successful call of enableAudioVolumeIndication , the SDK continuously detects which remote user has the loudest volume. During the current period, the remote user, who is detected as the loudest for the most times, is the most active user.When the number of users is no less than two and an active remote speaker exists, the SDK triggers this callback and reports the uid of the most active remote speaker.If the most active remote speaker is always the same user, the SDK triggers the onActiveSpeaker callback only once.If the most active remote speaker changes to another user, the SDK triggers this callback again and reports the uid of the new active remote speaker.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [uid] The user ID of the most active remote speaker.
  final void Function(RtcConnection connection, int uid)? onActiveSpeaker;

  /// Reports the result of video content moderation.
  /// After calling enableContentInspect to enable the video content moderation, and setting the type parameter in ContentInspectConfig tocontentInspectModeration, the SDK triggers the onContentInspectResult callback and reports the result of video content moderation.
  ///
  /// * [result] The results of video content moderation. See ContentInspectResult .
  final void Function(ContentInspectResult result)? onContentInspectResult;

  /// Reports the result of taking a video snapshot.
  /// After a successful takeSnapshot method call, the SDK triggers this callback to report whether the snapshot is successfully taken, as well as the details for that snapshot.
  ///
  /// * [uid] The user ID. A uid of 0 indicates the local user.
  /// * [filePath] The local path of the snapshot.
  /// * [width] The width (px) of the snapshot.
  /// * [height] The height (px) of the snapshot.
  /// * [errCode] The message that confirms success or gives the reason why the snapshot is not successfully taken:0: Success.< 0: Failure:-1: The SDK fails to write data to a file or encode a JPEG image.-2: The SDK does not find the video stream of the specified user within one second after the takeSnapshot method call succeeds.-3: Calling the takeSnapshot method too frequently.
  final void Function(RtcConnection connection, int uid, String filePath,
      int width, int height, int errCode)? onSnapshotTaken;

  /// Occurs when the user role switches in the interactive live streaming.
  /// The SDK triggers this callback when the local user switches the user role by calling setClientRole after joining the channel.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [oldRole] Role that the user switches from: ClientRoleType .
  /// * [newRole] Role that the user switches to: ClientRoleType .
  final void Function(
      RtcConnection connection,
      ClientRoleType oldRole,
      ClientRoleType newRole,
      ClientRoleOptions newRoleOptions)? onClientRoleChanged;

  /// Occurs when the user role switch fails in the interactive live streaming.
  /// In the live broadcasting channel profile, when the local user calls setClientRole [1/2] to switch their user role after joining the channel but the switch fails, the SDK triggers this callback to report the reason for the failure and the current user role.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [reason] The reason for a user role switch failure. See ClientRoleChangeFailedReason .
  /// * [currentRole] Current user role. See ClientRoleType .
  final void Function(
      RtcConnection connection,
      ClientRoleChangeFailedReason reason,
      ClientRoleType currentRole)? onClientRoleChangeFailed;

  /// @nodoc
  final void Function(MediaDeviceType deviceType, int volume, bool muted)?
      onAudioDeviceVolumeChanged;

  /// Occurs when the media push state changes.
  /// When the media push state changes, the SDK triggers this callback and reports the URL address and the current state of the media push. This callback indicates the state of the media push. When exceptions occur, you can troubleshoot issues by referring to the detailed error descriptions in the error code parameter.
  ///
  /// * [url] The URL address where the state of the media push changes.
  /// * [state] The current state of the media push. See RtmpStreamPublishState .
  /// * [errCode] The detailed error information for the media push. See RtmpStreamPublishErrorType .
  final void Function(String url, RtmpStreamPublishState state,
      RtmpStreamPublishErrorType errCode)? onRtmpStreamingStateChanged;

  /// Reports events during the media push.
  ///
  ///
  /// * [url] The URL of media push.
  /// * [eventCode] The event code of media push. See RtmpStreamingEvent .
  final void Function(String url, RtmpStreamingEvent eventCode)?
      onRtmpStreamingEvent;

  /// Occurs when the publisher's transcoding is updated.
  /// When the LiveTranscoding class in the setLiveTranscoding method updates, the SDK triggers the onTranscodingUpdated callback to report the update information.If you call the setLiveTranscoding method to set the LiveTranscoding class for the first time, the SDK does not trigger this callback.
  final void Function()? onTranscodingUpdated;

  /// Occurs when the local audio route changes.
  /// This method is for Android, iOS and macOS only.
  ///
  /// * [routing] The current audio routing. See AudioRoute .
  final void Function(int routing)? onAudioRoutingChanged;

  /// Occurs when the state of the media stream relay changes.
  /// The SDK returns the state of the current media relay with any error message.
  ///
  /// * [state] The state code. See ChannelMediaRelayState .
  /// * [code] The error code of the channel media relay. See ChannelMediaRelayError .
  final void Function(
          ChannelMediaRelayState state, ChannelMediaRelayError code)?
      onChannelMediaRelayStateChanged;

  /// Reports events during the media stream relay.
  ///
  ///
  /// * [code] The event code of channel media relay. See ChannelMediaRelayEvent .
  final void Function(ChannelMediaRelayEvent code)? onChannelMediaRelayEvent;

  /// @nodoc
  final void Function(bool isFallbackOrRecover)?
      onLocalPublishFallbackToAudioOnly;

  /// @nodoc
  final void Function(int uid, bool isFallbackOrRecover)?
      onRemoteSubscribeFallbackToAudioOnly;

  /// Reports the transport-layer statistics of each remote audio stream.
  /// Deprecated:Please use onRemoteAudioStats instead.This callback reports the transport-layer statistics, such as the packet loss rate and network time delay, once every two seconds after the local user receives an audio packet from a remote user. During a call, when the user receives the video packet sent by the remote user/host, the callback is triggered every 2 seconds.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user sending the audio packets.
  /// * [delay] The network delay (ms) from the sender to the receiver.
  /// * [lost] The packet loss rate (%) of the audio packet sent from the remote user.
  /// * [rxKBitRate] The bitrate of the received audio (Kbps).
  final void Function(RtcConnection connection, int remoteUid, int delay,
      int lost, int rxKBitRate)? onRemoteAudioTransportStats;

  /// Reports the transport-layer statistics of each remote video stream.
  /// Deprecated:This callback is deprecated; use onRemoteVideoStats instead.This callback reports the transport-layer statistics, such as the packet loss rate and network time delay, once every two seconds after the local user receives a video packet from a remote user.During a call, when the user receives the video packet sent by the remote user/host, the callback is triggered every 2 seconds.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [remoteUid] The ID of the remote user sending the video packets.
  /// * [delay] The network delay (ms) from the sender to the receiver.
  /// * [lost] The packet loss rate (%) of the video packet sent from the remote user.
  /// * [rxKBitRate] The bitrate of the received video (Kbps).
  final void Function(RtcConnection connection, int remoteUid, int delay,
      int lost, int rxKBitRate)? onRemoteVideoTransportStats;

  /// Occurs when the network connection state changes.
  /// When the network connection state changes, the SDK triggers this callback and reports the current connection state and the reason for the change.
  ///
  /// * [state] The current connection state.
  /// * [reason] The reason for a connection state change.
  final void Function(RtcConnection connection, ConnectionStateType state,
      ConnectionChangedReasonType reason)? onConnectionStateChanged;

  /// @nodoc
  final void Function(RtcConnection connection, WlaccMessageReason reason,
      WlaccSuggestAction action, String wlAccMsg)? onWlAccMessage;

  /// @nodoc
  final void Function(RtcConnection connection, WlAccStats currentStats,
      WlAccStats averageStats)? onWlAccStats;

  /// Occurs when the local network type changes.
  /// This callback occurs when the connection state of the local user changes. You can get the connection state and reason for the state change in this callback. When the network connection is interrupted, this callback indicates whether the interruption is caused by a network type change or poor network conditions.
  ///
  /// * [connection] The connection information. See RtcConnection .
  /// * [type] Network types: See NetworkType .
  final void Function(RtcConnection connection, NetworkType type)?
      onNetworkTypeChanged;

  /// Reports the built-in encryption errors.
  /// When encryption is enabled by calling enableEncryption , the SDK triggers this callback if an error occurs in encryption or decryption on the sender or the receiver side.
  ///
  /// * [connection] The connection information. See RtcConnection .
  ///
  final void Function(RtcConnection connection, EncryptionErrorType errorType)?
      onEncryptionError;

  /// Occurs when the SDK cannot get the device permission.
  /// When the SDK fails to get the device permission, the SDK triggers this callback to report which device permission cannot be got.This method is for Android and iOS only.
  ///
  /// * [permissionType] The type of the device permission. See PermissionType .
  final void Function(PermissionType permissionType)? onPermissionError;

  /// Occurs when the local user registers a user account.
  /// After the local user successfully calls registerLocalUserAccount to register the user account or calls joinChannelWithUserAccount to join a channel, the SDK triggers the callback and informs the local user's UID and User Account.
  ///
  /// * [uid] The ID of the local user.
  /// * [userAccount] The user account of the local user.
  final void Function(int uid, String userAccount)? onLocalUserRegistered;

  /// Occurs when the SDK gets the user ID and user account of the remote user.
  /// After a remote user joins the channel, the SDK gets the UID and user account of the remote user, caches them in a mapping table object, and triggers this callback on the local client.
  ///
  /// * [uid] The user ID of the remote user.
  /// * [info] The UserInfo object that contains the user ID and user account of the remote user. See UserInfo for details.
  final void Function(int uid, UserInfo info)? onUserInfoUpdated;

  /// @nodoc
  final void Function(RtcConnection connection, String requestId, bool success,
      UploadErrorReason reason)? onUploadLogResult;

  /// Occurs when the audio subscribing state changes.
  ///
  ///
  /// * [channel] The channel name.
  /// * [uid] The user ID of the remote user.
  /// * [oldState] The previous subscribing status, see StreamSubscribeState for details.
  /// * [newState] The current subscribing status, see StreamSubscribeState for details.
  /// * [elapseSinceLastState] The time elapsed (ms) from the previous state to the current state.
  final void Function(
      String channel,
      int uid,
      StreamSubscribeState oldState,
      StreamSubscribeState newState,
      int elapseSinceLastState)? onAudioSubscribeStateChanged;

  /// Occurs when the video subscribing state changes.
  ///
  ///
  /// * [channel] The channel name.
  /// * [uid] The ID of the remote user.
  /// * [oldState] The previous subscribing status, see StreamSubscribeState for details.
  /// * [newState] The current subscribing status, see StreamSubscribeState for details.
  /// * [elapseSinceLastState] The time elapsed (ms) from the previous state to the current state.
  final void Function(
      String channel,
      int uid,
      StreamSubscribeState oldState,
      StreamSubscribeState newState,
      int elapseSinceLastState)? onVideoSubscribeStateChanged;

  /// Occurs when the audio publishing state changes.
  ///
  ///
  /// * [channel] The channel name.
  /// * [oldState] The previous subscribing status. See StreamPublishState .
  /// * [newState] The current subscribing status. See StreamPublishState.
  /// * [elapseSinceLastState] The time elapsed (ms) from the previous state to the current state.
  final void Function(
      String channel,
      StreamPublishState oldState,
      StreamPublishState newState,
      int elapseSinceLastState)? onAudioPublishStateChanged;

  /// Occurs when the video publishing state changes.
  ///
  ///
  /// * [channel] The channel name.
  /// * [source] The capture type of the custom video source. See VideoSourceType .
  /// * [oldState] For the previous publishing state, see StreamPublishState .
  /// * [newState] For the current publishing state, see StreamPublishState.
  /// * [elapseSinceLastState] The time elapsed (ms) from the previous state to the current state.
  final void Function(
      VideoSourceType source,
      String channel,
      StreamPublishState oldState,
      StreamPublishState newState,
      int elapseSinceLastState)? onVideoPublishStateChanged;

  /// The event callback of the extension.
  /// To listen for events while the extension is running, you need to register this callback.
  ///
  /// * [value] The value of the extension key.
  /// * [key] The key of the extension.
  /// * [provider] The name of the extension provider.
  /// * [extName] The name of the extension.
  final void Function(
          String provider, String extension, String key, String value)?
      onExtensionEvent;

  /// Occurs when the extension is enabled.
  /// After a successful call of enableExtension (true), the extension triggers this callback.
  ///
  /// * [provider] The name of the extension provider.
  /// * [extName] The name of the extension.
  final void Function(String provider, String extension)? onExtensionStarted;

  /// Occurs when the extension is disabled.
  /// After a successful call of enableExtension (false), this callback is triggered.
  ///
  /// * [extName] The name of the extension.
  /// * [provider] The name of the extension provider.
  final void Function(String provider, String extension)? onExtensionStopped;

  /// Occurs when the extension runs incorrectly.
  /// When calling enableExtension (true) fails or the extension runs in error, the extension triggers this callback and reports the error code and reason.
  ///
  /// * [provider] The name of the extension provider.
  /// * [extension] The name of the extension.
  /// * [error] Error code. For details, see the extension documentation provided by the extension provider.
  /// * [message] Reason. For details, see the extension documentation provided by the extension provider.
  final void Function(
          String provider, String extension, int error, String message)?
      onExtensionError;

  /// @nodoc
  final void Function(
          RtcConnection connection, int remoteUid, String userAccount)?
      onUserAccountUpdated;

  const AgoraRtcEventHandlers({
    this.onJoinChannelSuccess,
    this.onRejoinChannelSuccess,
    this.onProxyConnected,
    this.onError,
    this.onAudioQuality,
    this.onLastmileProbeResult,
    this.onAudioVolumeIndication,
    this.onLeaveChannel,
    this.onRtcStats,
    this.onAudioDeviceStateChanged,
    this.onAudioMixingFinished,
    this.onAudioEffectFinished,
    this.onVideoDeviceStateChanged,
    this.onNetworkQuality,
    this.onIntraRequestReceived,
    this.onUplinkNetworkInfoUpdated,
    this.onDownlinkNetworkInfoUpdated,
    this.onLastmileQuality,
    this.onFirstLocalVideoFrame,
    this.onFirstLocalVideoFramePublished,
    this.onFirstRemoteVideoDecoded,
    this.onVideoSizeChanged,
    this.onLocalVideoStateChanged,
    this.onRemoteVideoStateChanged,
    this.onFirstRemoteVideoFrame,
    this.onUserJoined,
    this.onUserOffline,
    this.onUserMuteAudio,
    this.onUserMuteVideo,
    this.onUserEnableVideo,
    this.onUserStateChanged,
    this.onUserEnableLocalVideo,
    this.onLocalAudioStats,
    this.onRemoteAudioStats,
    this.onLocalVideoStats,
    this.onRemoteVideoStats,
    this.onCameraReady,
    this.onCameraFocusAreaChanged,
    this.onCameraExposureAreaChanged,
    this.onFacePositionChanged,
    this.onVideoStopped,
    this.onAudioMixingStateChanged,
    this.onRhythmPlayerStateChanged,
    this.onConnectionLost,
    this.onConnectionInterrupted,
    this.onConnectionBanned,
    this.onStreamMessage,
    this.onStreamMessageError,
    this.onRequestToken,
    this.onTokenPrivilegeWillExpire,
    this.onFirstLocalAudioFramePublished,
    this.onFirstRemoteAudioFrame,
    this.onFirstRemoteAudioDecoded,
    this.onLocalAudioStateChanged,
    this.onRemoteAudioStateChanged,
    this.onActiveSpeaker,
    this.onContentInspectResult,
    this.onSnapshotTaken,
    this.onClientRoleChanged,
    this.onClientRoleChangeFailed,
    this.onAudioDeviceVolumeChanged,
    this.onRtmpStreamingStateChanged,
    this.onRtmpStreamingEvent,
    this.onTranscodingUpdated,
    this.onAudioRoutingChanged,
    this.onChannelMediaRelayStateChanged,
    this.onChannelMediaRelayEvent,
    this.onLocalPublishFallbackToAudioOnly,
    this.onRemoteSubscribeFallbackToAudioOnly,
    this.onRemoteAudioTransportStats,
    this.onRemoteVideoTransportStats,
    this.onConnectionStateChanged,
    this.onWlAccMessage,
    this.onWlAccStats,
    this.onNetworkTypeChanged,
    this.onEncryptionError,
    this.onPermissionError,
    this.onLocalUserRegistered,
    this.onUserInfoUpdated,
    this.onUploadLogResult,
    this.onAudioSubscribeStateChanged,
    this.onVideoSubscribeStateChanged,
    this.onAudioPublishStateChanged,
    this.onVideoPublishStateChanged,
    this.onExtensionEvent,
    this.onExtensionStarted,
    this.onExtensionStopped,
    this.onExtensionError,
    this.onUserAccountUpdated,
  });
}
