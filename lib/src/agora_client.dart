import 'dart:async';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_event_handlers.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// [AgoraClient] is the main class in this UIKit. It is used to initialize our [RtcEngine], add the list of user permissions, define the channel properties and use extend the [RtcEngineEventHandler] class.
class AgoraClient {
  static const MethodChannel _channel = MethodChannel('agora_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<List<int>> get users async {
    final List<int> version =
        _sessionController.value.users.map((e) => e.uid).toList();
    return version;
  }

  // This is our "state" object that the UI Kit works with
  final SessionController _sessionController = SessionController();
  SessionController get sessionController {
    return _sessionController;
  }

  AgoraClient({
    required AgoraConnectionData agoraConnectionData,
    required List<Permission> enabledPermission,
    AgoraChannelData? agoraChannelData,
    AgoraEventHandlers? agoraEventHandlers,
  }) {
    _initAgoraRtcEngine(
      agoraConnectionData: agoraConnectionData,
      enabledPermission: enabledPermission,
      agoraChannelData: agoraChannelData,
      agoraEventHandlers: agoraEventHandlers,
    );
  }

  Future<void> _initAgoraRtcEngine({
    required AgoraConnectionData agoraConnectionData,
    required List<Permission> enabledPermission,
    AgoraChannelData? agoraChannelData,
    AgoraEventHandlers? agoraEventHandlers,
  }) async {
    try {
      _sessionController.initializeEngine(
        agoraConnectionData: agoraConnectionData,
      );
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    _sessionController.createEvents(agoraEventHandlers);

    if (agoraChannelData != null) {
      _sessionController.setChannelProperties(agoraChannelData);
    }

    _sessionController.joinVideoChannel();
  }
}
