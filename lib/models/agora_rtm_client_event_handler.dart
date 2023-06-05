import 'package:agora_rtm/agora_rtm.dart';

/// Handles all the callbacks or event handler for the Agora RTM client class
class AgoraRtmClientEventHandler {
  /// Occurs when you receive error events.
  final void Function(dynamic error)? onError;

  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  final void Function(int state, int reason)? onConnectionStateChanged;

  /// Occurs when the local user receives a peer-to-peer message.
  final void Function(RtmMessage message, String peerId)? onMessageReceived;

  /// Occurs when your token expires.
  final void Function()? onTokenExpired;

  final void Function()? onTokenPrivilegeWillExpire;

  final void Function(Map<String, bool> peersStatus)?
      onPeersOnlineStatusChanged;

  const AgoraRtmClientEventHandler({
    this.onError,
    this.onConnectionStateChanged,
    this.onMessageReceived,
    this.onTokenExpired,
    this.onTokenPrivilegeWillExpire,
    this.onPeersOnlineStatusChanged,
  });
}
