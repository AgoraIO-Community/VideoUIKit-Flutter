import 'dart:io';

/// Class to send the mute request for camera and microphone.
class MuteRequest {
  MuteRequest(
      {required this.rtcId,
      required this.mute,
      required this.device,
      required this.isForceful});
  String messageType = "MuteRequest";
  final int rtcId;
  final bool mute;
  final int device;
  final bool isForceful;

  MuteRequest.fromJson(Map<String, dynamic> json)
      : messageType = json['messageType'],
        rtcId = json['rtcId'],
        mute = json['mute'],
        device = json['device'],
        isForceful = json['isForceful'];

  Map<String, dynamic> toJson() => {
        'messageType': messageType,
        'rtcId': rtcId,
        'mute': mute,
        'device': device,
        'isForceful': isForceful
      };
}

/// Class to store and share the user data for RTC and RTM operations
class UserData {
  UserData({
    required this.rtmId,
    required this.rtcId,
    required this.username,
    required this.role,
  });
  String messageType = "UserData";

  /// ID used in the RTM connection
  late String rtmId;

  /// ID used in the RTC (Video/Audio) connection
  late int rtcId;

  /// Username to be displayed for remote users
  String? username;

  /// Role of the user (broadcaster or audience)
  late int role; // Int, broadcaster = 0, audience = 1

  /// Agora VideoUIKit platform, framework, and version
  var uikit = AgoraUIKit().toJson();

  /// Properties about the Agora SDK versions this user is using
  var agora = AgoraVersions().toJson();

  UserData.fromJson(Map<String, dynamic> json) {
    messageType = json['messageType'];
    rtmId = json['rtmId'];
    rtcId = json['rtcId'];
    username = json['username'];
    role = json['role'];
    agora = json['agora'];
    uikit = json['uikit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['messageType'] = messageType;
    data['rtmId'] = rtmId;
    data['rtcId'] = rtcId;
    data['username'] = username;
    data['role'] = role;
    data['agora'] = agora;
    data['uikit'] = uikit;
    return data;
  }
}

class AgoraUIKit {
  AgoraUIKit();

  static String platformStr() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isMacOS) {
      return "macos";
    } else if (Platform.isWindows) {
      return "windows";
    }
    return "web";
  }

  String platform = platformStr();

  String framework = "flutter";
  String version = "1.0.4";

  AgoraUIKit.fromJson(Map<String, dynamic> json)
      : platform = json['platform'],
        framework = json['framework'],
        version = json['version'];

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'framework': framework,
        'version': version,
      };
}

/// Class to store and share the Agora version for RTC and RTM
class AgoraVersions {
  AgoraVersions();
  static String staticRTM = '1.1.1';
  static String staticRTC = '5.2.0';
  String rtm = AgoraVersions.staticRTM;
  String rtc = AgoraVersions.staticRTC;

  AgoraVersions.fromJson(Map<String, dynamic> json)
      : rtm = json['rtm'],
        rtc = json['rtc'];

  Map<String, dynamic> toJson() => {'rtm': rtm, 'rtc': rtc};
}
