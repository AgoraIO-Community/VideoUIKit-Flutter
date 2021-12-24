import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  /// The App ID issued to you by Agora. See [How to get the App ID](). Only users in apps with the same App ID can join the same channel and communicate with each other.
  final String appId;

  /// Specifies the channel to join
  final String channelName;

  /// (Optional) The user ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1). This parameter must be unique. If uid is not assigned (or set as 0), the SDK assigns a uid and reports it in the onJoinChannelSuccess callback.
  final int uid;

  /// (Optional) Link to the deployed token server. The UIKit automatically generates the token after a fixed interval. Have a look at this guide to learn how to set up your [token server](https://github.com/AgoraIO-Community/agora-token-service)
  final String? tokenUrl;

  /// (Optional) Link to start cloud recording
  final String? recordUrl;

  /// (Optional) Link to stop cloud recording
  final String? stopRecordUrl;

  /// (Optional) Link to get cloud recording resource id
  final String? getResourceIdUrl;

  /// (Optional) Token value generated from the Agora dashboard.
  final String? tempToken;

  /// (Optional) The region for connection. This advanced feature applies to scenarios that have regional restrictions.
  final List<AreaCode> areaCode;

  /// Cloud Recorder UID Should not be the same as anyone joining the channel
  final int recUid;

  AgoraConnectionData({
    required this.appId,
    required this.channelName,
    this.uid = 0,
    this.recUid = 1,
    this.tokenUrl,
    this.tempToken,
    this.recordUrl,
    this.stopRecordUrl,
    this.getResourceIdUrl,
    this.areaCode = const [AreaCode.GLOB],
  });

  AgoraConnectionData copyWith({
    String? appId,
    String? channelName,
    int? uid,
    int? recUid,
    String? tempToken,
    String? tokenUrl,
    List<AreaCode>? areaCode,
    String? recordUrl,
    String? stopRecordUrl,
    String? getResourceIdUrl,
  }) {
    return AgoraConnectionData(
      appId: appId ?? this.appId,
      channelName: channelName ?? this.channelName,
      uid: uid ?? this.uid,
      tempToken: tempToken ?? this.tempToken,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      areaCode: areaCode ?? this.areaCode,
      recordUrl: recordUrl ?? this.recordUrl,
      stopRecordUrl: stopRecordUrl ?? this.stopRecordUrl,
      getResourceIdUrl: getResourceIdUrl ?? this.getResourceIdUrl,
      recUid: recUid ?? this.recUid,
    );
  }
}
