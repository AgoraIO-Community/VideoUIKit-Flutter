import 'package:agora_uikit/src/enums.dart';
import 'package:flutter/material.dart';

/// Displays the camera and microphone state of local and remote user. Currently, this mode is only available in the [Layout.floating].
class UserAVStateWidget extends StatefulWidget {
  final bool videoDisabled;
  final bool muted;

  const UserAVStateWidget({
    Key? key,
    required this.videoDisabled,
    required this.muted,
  }) : super(key: key);

  @override
  _UserAVStateWidgetState createState() => _UserAVStateWidgetState();
}

class _UserAVStateWidgetState extends State<UserAVStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.videoDisabled ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: widget.videoDisabled
                      ? Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: 15,
                        )
                      : Icon(
                          Icons.videocam,
                          color: Colors.blue,
                          size: 15,
                        ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.muted ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: widget.muted
                      ? Icon(
                          Icons.mic_off,
                          color: Colors.white,
                          size: 15,
                        )
                      : Icon(
                          Icons.mic,
                          color: Colors.blue,
                          size: 15,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
