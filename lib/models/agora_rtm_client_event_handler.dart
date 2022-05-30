import 'package:agora_rtm/agora_rtm.dart';

/// Handles all the callbacks or event handler for the Agora RTM client class
class AgoraRtmClientEventHandler {
  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  final Function(int, int)? onConnectionStateChanged;

  /// Occurs when the local user receives a peer-to-peer message.
  final Function(AgoraRtmMessage message, String peerId)? onMessageReceived;

  /// Occurs when your token expires.
  final Function()? onTokenExpired;

  /// Occurs when you receive error events.
  final Function(dynamic error)? onError;

  /// Callback to the caller: occurs when the caller receives the call invitation.
  final Function(AgoraRtmLocalInvitation)? onLocalInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the caller accepts the call invitation.
  final Function(AgoraRtmLocalInvitation)? onLocalInvitationAccepted;

  /// Callback to the caller: occurs when the caller declines the call invitation.
  final Function(AgoraRtmLocalInvitation)? onLocalInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  final Function(AgoraRtmLocalInvitation)? onLocalInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  final Function(AgoraRtmLocalInvitation, int)? onLocalInvitationFailure;

  /// Callback to the caller: occurs when the callee receives the call invitation.
  final Function(AgoraRtmRemoteInvitation)? onRemoteInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the callee accepts the call invitation.
  final Function(AgoraRtmRemoteInvitation)? onRemoteInvitationAccepted;

  /// Callback to the caller: occurs when the callee declines the call invitation.
  final Function(AgoraRtmRemoteInvitation)? onRemoteInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  final Function(AgoraRtmRemoteInvitation)? onRemoteInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  final Function(AgoraRtmRemoteInvitation, int)? onRemoteInvitationFailure;

  const AgoraRtmClientEventHandler({
    this.onConnectionStateChanged,
    this.onMessageReceived,
    this.onTokenExpired,
    this.onError,
    this.onLocalInvitationAccepted,
    this.onLocalInvitationRefused,
    this.onLocalInvitationCanceled,
    this.onRemoteInvitationAccepted,
    this.onRemoteInvitationRefused,
    this.onRemoteInvitationCanceled,
    this.onLocalInvitationFailure,
    this.onRemoteInvitationFailure,
    this.onLocalInvitationReceivedByPeer,
    this.onRemoteInvitationReceivedByPeer,
  });
}
