import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:http/http.dart' as http;

Future<void> getRtmToken({
  String? tokenUrl,
  required SessionController sessionController,
}) async {
  final String url = "$tokenUrl/rtm/${sessionController.value.generatedRtmId}";
  final rtmResponse = await http.get(Uri.parse(url));
  if (rtmResponse.statusCode == HttpStatus.ok) {
    sessionController.value = sessionController.value.copyWith(
      generatedRtmToken: jsonDecode(rtmResponse.body)['rtmToken'],
    );
  } else {
    log("${rtmResponse.reasonPhrase}", level: Level.error.value);
    log('Failed to generate the rtm token : ${rtmResponse.statusCode}',
        level: Level.error.value);
  }
}
