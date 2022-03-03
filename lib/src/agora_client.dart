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
  /// [AgoraConnectionData] is a class used to store all the connection details to authenticate your account with the Agora SDK.
  final AgoraConnectionData agoraConnectionData;

  /// [enabledPermission] is a list of permissions that the user has to grant to the app. By default the UIKit asks for the camera and microphone permissions for every broadcaster that joins the channel.
  final List<Permission>? enabledPermission;

  /// [AgoraChannelData] is a class that contains all the Agora channel properties.
  final AgoraChannelData? agoraChannelData;

  /// [AgoraEventHandlers] is a class that contains all the Agora event handlers. Use it to add your own functions or methods.
  final AgoraEventHandlers? agoraEventHandlers;

  bool _initialized = false;

  AgoraClient({
    required this.agoraConnectionData,
    this.enabledPermission,
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

    if (agoraChannelData?.clientRole == ClientRole.Broadcaster ||
        agoraChannelData?.clientRole == null) {
      await _sessionController.askForUserCameraAndMicPermission();
    }
    if (enabledPermission != null) {
      await enabledPermission!.request();
    }

    _sessionController.createEvents(agoraEventHandlers ?? AgoraEventHandlers());

    if (agoraChannelData != null) {
      _sessionController.setChannelProperties(agoraChannelData!);
    }

    await _sessionController.joinVideoChannel();
    _initialized = true;
  }
}
