/// Class to decode the AgoraRtmMessage
class Message {
  final String text;
  final int? ts;
  final bool? offline;

  Message({required this.text, this.ts, this.offline});

  Map<String, dynamic> toJson() => {
        'text': text,
        'ts': ts,
        'offline': offline,
      };
}
