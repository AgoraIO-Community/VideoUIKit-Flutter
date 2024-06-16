import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtm_mute_request.dart';
import 'package:flutter/material.dart';

class HostControls extends StatefulWidget {
  final AgoraClient client;
  final bool videoDisabled;
  final bool muted;
  final int index;

  const HostControls({
    super.key,
    required this.videoDisabled,
    required this.muted,
    required this.client,
    required this.index,
  });

  @override
  State<HostControls> createState() => _HostControlsState();
}

class _HostControlsState extends State<HostControls> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      enableFeedback: true,
      tooltip: 'Host Controls',
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              hostControl(
                index: widget.index,
                mute: !widget.muted,
                sessionController: widget.client.sessionController,
                device: Device.mic,
              );
              Navigator.pop(context);
            },
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.muted ? Icons.mic_off : Icons.mic,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  widget.muted
                      ? Text(
                          'Ask user to unmute the mic',
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          'Ask user to mute the mic',
                          style: TextStyle(fontSize: 15),
                        )
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              hostControl(
                index: widget.index,
                mute: !widget.videoDisabled,
                sessionController: widget.client.sessionController,
                device: Device.camera,
              );
              Navigator.pop(context);
            },
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.videoDisabled ? Icons.videocam_off : Icons.videocam,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  widget.videoDisabled
                      ? Text(
                          'Ask user to turn on the camera',
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          'Ask user to turn off the camera',
                          style: TextStyle(fontSize: 15),
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
