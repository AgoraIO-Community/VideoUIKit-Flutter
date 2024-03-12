import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:flutter/material.dart';

class CloudRecordingButton extends StatelessWidget {
  final Widget? child;
  final AgoraClient client;
  const CloudRecordingButton({
    super.key,
    required this.client,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child != null
        ? RawMaterialButton(
            onPressed: () => toggleCloudRecording(client: client),
            child: child,
          )
        : RecordingStateButton(
            client: client,
          );
  }
}

class RecordingStateButton extends StatelessWidget {
  final AgoraClient client;
  const RecordingStateButton({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    switch (client.sessionController.value.isCloudRecording) {
      case RecordingState.off:
        return RawMaterialButton(
          onPressed: () => toggleCloudRecording(client: client),
          child: Icon(
            Icons.circle_outlined,
            color: Colors.blueAccent,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
        );
      case RecordingState.loading:
        return RawMaterialButton(
          onPressed: () {},
          child: Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
        );
      case RecordingState.recording:
        return RawMaterialButton(
          onPressed: () => toggleCloudRecording(client: client),
          child: Icon(
            Icons.stop,
            color: Colors.white,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.blueAccent,
          padding: const EdgeInsets.all(12.0),
        );
      default:
        return RawMaterialButton(
          onPressed: () {},
          child: CircularProgressIndicator(),
        );
    }
  }
}
