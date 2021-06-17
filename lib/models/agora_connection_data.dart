import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  /// The App ID issued to you by Agora. See [How to get the App ID](). Only users in apps with the same App ID can join the same channel and communicate with each other.
  final String appId;

  /// Specifies the channel to join
  final String channelName;

  /// (Optional) The user ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1). This parameter must be unique. If uid is not assigned (or set as 0), the SDK assigns a uid and reports it in the onJoinChannelSuccess callback.
  final int? uid;

  /// (Optional) Link to the deployed token server. The UIKit automatically generates the token after a fixed interval. Have a look at this guide to learn how to set up your [token server](https://github.com/AgoraIO-Community/agora-token-service)
  final String? tokenUrl;

  /// (Optional) Token value generated from the Agora dashboard.
  final String? tempToken;

  /// (Optional) The region for connection. This advanced feature applies to scenarios that have regional restrictions.
  final AreaCode areaCode;

  AgoraConnectionData({
    required this.appId,
    required this.channelName,
    this.uid,
    this.tokenUrl,
    this.tempToken,
    this.areaCode = AreaCode.GLOB,
  });

  AgoraConnectionData copyWith({
    String? appId,
    String? channelName,
    int? uid,
    String? tempToken,
    String? tokenUrl,
    AreaCode? areaCode,
  }) {
    return AgoraConnectionData(
      appId: appId ?? this.appId,
      channelName: channelName ?? this.channelName,
      uid: uid ?? this.uid,
      tempToken: tempToken ?? this.tempToken,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      areaCode: areaCode ?? this.areaCode,
    );
  }
}
