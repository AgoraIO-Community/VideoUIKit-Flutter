import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:flutter/material.dart';

import '../agora_client.dart';

class CloudRecordingButton extends StatelessWidget {
  final Widget? child;
  final AgoraClient client;
  const CloudRecordingButton({
    Key? key,
    required this.client,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child != null
        ? RawMaterialButton(
            onPressed: () => toggleCloudRecording(client: client),
            child: child,
          )
        : RawMaterialButton(
            onPressed: () => toggleCloudRecording(client: client),
            child: Icon(
              client.sessionController.value.isCloudRecording
                  ? Icons.stop
                  : Icons.circle_outlined,
              color: client.sessionController.value.isCloudRecording
                  ? Colors.white
                  : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: client.sessionController.value.isCloudRecording
                ? Colors.blueAccent
                : Colors.white,
            padding: const EdgeInsets.all(12.0),
          );
  }
}
