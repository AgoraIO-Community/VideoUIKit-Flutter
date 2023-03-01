import 'package:flutter/material.dart';

import 'package:agora_uikit/agora_uikit.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Agora VideoUIKit',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "<--Add your App Id here-->",
      channelName: "test",
      username: "user",
    ),
    // Allows you to add a screen before the Video Calling page to check your video and network state.
    addPreCallScreen: true,
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraPreCallViewer(
              client: client,
              joinCallButton: () {
                // Add Navigation to your call page here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallingClass(client: client),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCallingClass extends StatefulWidget {
  final AgoraClient client;

  const VideoCallingClass({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<VideoCallingClass> createState() => _VideoCallingClassState();
}

class _VideoCallingClassState extends State<VideoCallingClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: widget.client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: widget.client,
              addScreenSharing: false, // Add this to enable screen sharing
            ),
          ],
        ),
      ),
    );
  }
}
