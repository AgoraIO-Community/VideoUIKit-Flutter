import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:flutter/material.dart';

class CloudRecordingButton extends StatelessWidget {
  final SessionController sessionController;
  const CloudRecordingButton({
    Key? key,
    required this.sessionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () =>
          toggleCloudRecording(sessionController: sessionController),
      child: Icon(
        sessionController.value.isCloudRecording
            ? Icons.stop
            : Icons.circle_outlined,
        color: sessionController.value.isCloudRecording
            ? Colors.white
            : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: sessionController.value.isCloudRecording
          ? Colors.blueAccent
          : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }
}

class CustomCloudRecordingButton extends StatelessWidget {
  final Widget child;
  final SessionController sessionController;
  const CustomCloudRecordingButton({
    Key? key,
    required this.child,
    required this.sessionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () =>
          toggleCloudRecording(sessionController: sessionController),
      child: child,
    );
  }
}
