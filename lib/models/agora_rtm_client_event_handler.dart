import 'package:agora_rtm/agora_rtm.dart';

/// Handles all the callbacks or event handler for the Agora RTM client class
class AgoraRtmClientEventHandler {
  /// Occurs when you receive error events.
  final void Function(dynamic error)? onError;

  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  final void Function(
          RtmConnectionState state, RtmConnectionChangeReason reason)?
      onConnectionStateChanged2;

  /// Occurs when the local user receives a peer-to-peer message.
  final void Function(RtmMessage message, String peerId)? onMessageReceived;

  /// Occurs when your token expires.
  final void Function()? onTokenExpired;

  final void Function()? onTokenPrivilegeWillExpire;

  final void Function(Map<String, RtmPeerOnlineState> peersStatus)?
      onPeersOnlineStatusChanged;

  const AgoraRtmClientEventHandler({
    this.onError,
    this.onMessageReceived,
    this.onTokenExpired,
    this.onTokenPrivilegeWillExpire,
    this.onConnectionStateChanged2,
    this.onPeersOnlineStatusChanged,
  });
}
