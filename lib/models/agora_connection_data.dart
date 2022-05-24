import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  /// The App ID issued to you by Agora. See [How to get the App ID](). Only users in apps with the same App ID can join the same channel and communicate with each other.
  final String appId;

  /// Specifies the channel to join
  final String channelName;

  final String? rtmChannelName;

  /// (Optional) The RTC user ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1). This parameter must be unique. If uid is not assigned (or set as 0), the SDK assigns a uid and reports it in the onJoinChannelSuccess callback.
  final int uid;

  /// (Optional) The RTM user ID. A String value. If you don't provide a rtmUid, the UIKit automatically assigns a rtmUid based on timestamp.
  final String? rtmUid;

  /// (Optional) If you want to enable RTM to your application (for features like host control) make sure that you pass in a username to AgoraConnectionData.
  final String? username;

  /// (Optional) Link to the deployed token server. The UIKit automatically generates the token after a fixed interval. Have a look at this guide to learn how to set up your [token server](https://github.com/AgoraIO-Community/agora-token-service)
  final String? tokenUrl;

  /// (Optional) RTC Token value generated from the Agora dashboard.
  final String? tempToken;

  /// (Optional) RTM Token value generated from the Agora dashboard.
  final String? tempRtmToken;

  /// (Optional) The region for connection. This advanced feature applies to scenarios that have regional restrictions.
  final List<AreaCode> areaCode;

  /// Whether you want to enable RTM or not. Enabling RTM adds the host controls which helps you to request a remote user to mute/unmute their video/mic. Host Controls are enabled by default, set this to `false` to disable it.
  final bool rtmEnabled;

  AgoraConnectionData({
    required this.appId,
    required this.channelName,
    this.rtmChannelName,
    this.uid = 0,
    this.rtmUid,
    this.username,
    this.tokenUrl,
    this.tempToken,
    this.tempRtmToken,
    this.areaCode = const [AreaCode.GLOB],
    this.rtmEnabled = true,
  });

  AgoraConnectionData copyWith({
    String? appId,
    String? channelName,
    String? rtmChannelName,
    int? uid,
    String? rtmUid,
    String? username,
    String? tempToken,
    String? tempRtmToken,
    String? tokenUrl,
    List<AreaCode>? areaCode,
    bool? rtmEnabled,
  }) {
    return AgoraConnectionData(
      appId: appId ?? this.appId,
      channelName: channelName ?? this.channelName,
      rtmChannelName: rtmChannelName ?? this.rtmChannelName,
      uid: uid ?? this.uid,
      rtmUid: rtmUid ?? this.rtmUid,
      username: username ?? this.username,
      tempToken: tempToken ?? this.tempToken,
      tempRtmToken: tempRtmToken ?? this.tempRtmToken,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      areaCode: areaCode ?? this.areaCode,
      rtmEnabled: rtmEnabled ?? this.rtmEnabled,
    );
  }
}
