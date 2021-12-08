import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_channel_data.dart';
import 'package:agora_uikit/models/agora_connection_data.dart';
import 'package:agora_uikit/models/agora_event_handlers.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// [AgoraClient] is the main class in this UIKit. It is used to initialize our [RtcEngine], add the list of user permissions, define the channel properties and use extend the [RtcEngineEventHandler] class.
class AgoraClient {
  final AgoraConnectionData agoraConnectionData;
  final List<Permission> enabledPermission;
  final AgoraChannelData? agoraChannelData;
  final AgoraEventHandlers? agoraEventHandlers;

  bool _initialized = false;

  AgoraClient({
    required this.agoraConnectionData,
    required this.enabledPermission,
    this.agoraChannelData,
    this.agoraEventHandlers,
  }) : _initialized = false;

  /// Useful to check if [AgoraClient] is ready for further usage
  bool get isInitialized => _initialized;

  static const MethodChannel _channel = MethodChannel('agora_uikit');

  static Future<String> platformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  List<int> get users {
    final List<int> version =
        _sessionController.value.users.map((e) => e.uid).toList();
    return version;
  }

  // This is our "state" object that the UI Kit works with
  final SessionController _sessionController = SessionController();
  SessionController get sessionController {
    return _sessionController;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (agoraConnectionData.username == null) {
      try {
        await _sessionController.initializeEngine(
            agoraConnectionData: agoraConnectionData);
      } catch (e) {
        print("Error while initializing Agora SDK");
      }
    } else {
      try {
        await _sessionController.initializeEngine(
          agoraConnectionData: agoraConnectionData,
        );
        await _sessionController.initializeRtm();
      } catch (e) {
        print("Error while initializing Agora SDK. ${e.toString()}");
      }
    }

    await enabledPermission.request();

    // await _sessionController.rtmStuff();

    await _sessionController.loginToRtm();

    _sessionController.createEvents(agoraEventHandlers ?? AgoraEventHandlers());

    if (agoraChannelData != null) {
      _sessionController.setChannelProperties(agoraChannelData!);
    }

    await _sessionController.joinVideoChannel();

    _initialized = true;
  }
}
