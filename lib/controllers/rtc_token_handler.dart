import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:http/http.dart' as http;

/// Function to get the RTC token from the server. Follow the server implementation.
Future<String> getRtcToken({
  required String tokenUrl,
  required String channelName,
  required String uid,
  String role = "publisher",
  int expire = 3600,
}) async {
  final base = Uri.parse(tokenUrl);

  final response = await http.post(
    base.resolve("/getToken"),
    body: {
      "tokenType": "rtc",
      "channel": channelName,
      "role": role,
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

Future<String?> generateRtcToken(SessionController sessionController) async {
  final tokenUrl = sessionController.value.connectionData!.tokenUrl;
  if (tokenUrl == null) {
    log("Token URL is null", level: Level.error.value, name: "AgoraVideoUIKit");
    return null;
  }
  try {
    final token = await getRtcToken(
      tokenUrl: tokenUrl,
      channelName: sessionController.value.connectionData!.channelName,
      uid: sessionController.value.connectionData!.uid.toString(),
    );
    sessionController.value = sessionController.value.copyWith(generatedToken: token);
    return token;
  } catch (e, s) {
    log(e.toString(), stackTrace: s, level: Level.error.value, name: "AgoraVideoUIKit");
    return null;
  }
}
