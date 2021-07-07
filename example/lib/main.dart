import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AgoraClient client;
  Future<void> futureInitialize;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "<--Add your App Id here-->",
        channelName: "test",
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );
    futureInitialize = client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UIKit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: futureInitialize,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred.'));
              }
              return Stack(
                children: [
                  AgoraVideoViewer(
                    layoutType: Layout.floating,
                    client: client,
                  ),
                  AgoraVideoButtons(
                    client: client,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
