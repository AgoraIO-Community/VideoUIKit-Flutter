import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:http/http.dart' as http;

Future<String> getRtmToken({
  required String tokenUrl,
  required String channelName,
  required String uid,
  int expire = 3600,
}) async {
  final base = Uri.parse(tokenUrl);

  final response = await http.post(
    base.resolve("/getToken"),
    body: {
      "tokenType": "rtm",
      "channel": channelName,
      "uid": uid, // the server expects a string
      "expire": expire, // optional: expiration time in seconds (default: 3600)
    },
  );

  if (response.statusCode == HttpStatus.ok) {
    return jsonDecode(response.body)['token'];
  } else {
    log("${response.reasonPhrase}", level: Level.error.value, name: "AgoraVideoUIKit");
    log("Failed to generate the token : ${response.statusCode}", level: Level.error.value, name: "AgoraVideoUIKit");
    throw Exception("Failed to generate the token : ${response.statusCode}");
  }
}

Future<String?> generateRtmToken(SessionController sessionController) async {
  final tokenUrl = sessionController.value.connectionData!.tokenUrl;
  if (tokenUrl == null) {
    log("Token URL is null", level: Level.error.value, name: "AgoraVideoUIKit");
    return null;
  }
  final rtcChannelName = sessionController.value.connectionData!.channelName;
  final rtmChannelName = sessionController.value.connectionData!.rtmChannelName;

  final rtcUid = sessionController.value.connectionData!.uid.toString();
  final rtmUid = sessionController.value.connectionData!.rtmUid;

  try {
    final token = await getRtmToken(
      tokenUrl: tokenUrl,
      channelName: rtmChannelName ?? rtcChannelName,
      uid: rtmUid ?? rtcUid,
    );
    sessionController.value = sessionController.value.copyWith(generatedRtmToken: token);
    return token;
  } catch (e, s) {
    log(e.toString(), stackTrace: s, level: Level.error.value, name: "AgoraVideoUIKit");
    return null;
  }
}
