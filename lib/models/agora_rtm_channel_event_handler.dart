import 'package:agora_rtm/agora_rtm.dart';

class AgoraRtmChannelEventHandler {
  /// Occurs when you receive error events.
  final Function(dynamic error)? onError;

  /// Occurs when receiving a channel message.
  final Function(RtmMessage message, RtmChannelMember fromMember)?
      onMessageReceived;

  /// Occurs when a user joins the channel.
  final Function(RtmChannelMember member)? onMemberJoined;

  /// Occurs when a channel member leaves the channel.
  final Function(RtmChannelMember member)? onMemberLeft;

  /// Occurs when channel attribute updated.
  final Function(List<RtmChannelAttribute> attributes)? onAttributesUpdated;

  /// Occurs when channel member count updated.
  final Function(int count)? onMemberCountUpdated;

  const AgoraRtmChannelEventHandler({
    this.onError,
    this.onMessageReceived,
    this.onMemberJoined,
    this.onMemberLeft,
    this.onAttributesUpdated,
    this.onMemberCountUpdated,
  });
}
