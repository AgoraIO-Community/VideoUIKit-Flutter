import 'dart:async';
import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/src/layout/floating_layout.dart';
import 'package:agora_uikit/src/layout/grid_layout.dart';
import 'package:agora_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

/// A UI class to style how the video layout looks like. Use this class to choose between the two default layouts [FloatingLayout] and [GridLayout], enable active speaker, display number of users, display mic and video state of the user.
class AgoraVideoViewer extends StatefulWidget {
  final AgoraClient client;

  /// Choose between two default layouts [Layout.floating] and [Layout.grid]
  final Layout layoutType;

  /// Set the height of the container in the floating view. The default height is 0.2 of the total height.
  final double? floatingLayoutContainerHeight;

  /// Set the width of the container in the floating view. The default width is 1/3 of the total width.
  final double? floatingLayoutContainerWidth;

  /// Padding of the main user or the active speaker in the floating layout.
  final EdgeInsets floatingLayoutMainViewPadding;

  /// Padding of the secondary user present in the list.
  final EdgeInsets floatingLayoutSubViewPadding;

  /// Widget that will be displayed when the local or remote user has disabled it's video.
  final Widget disabledVideoWidget;

  /// Display the camera and microphone status of a user. This feature is only available in the [Layout.floating]
  final bool showAVState;

  /// Display the total number of users in a channel.
  final bool showNumberOfUsers;

  /// Render mode for local and remote video
  final VideoRenderMode videoRenderMode;

  const AgoraVideoViewer({
    Key? key,
    required this.client,
    this.layoutType = Layout.grid,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.floatingLayoutMainViewPadding = const EdgeInsets.fromLTRB(3, 0, 3, 3),
    this.floatingLayoutSubViewPadding = const EdgeInsets.fromLTRB(3, 3, 0, 3),
    this.disabledVideoWidget = const DisabledVideoWidget(),
    this.showAVState = false,
    this.showNumberOfUsers = false,
    this.videoRenderMode = VideoRenderMode.Hidden,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  @override
  void initState() {
    widget.client.sessionController
        .updateLayoutType(updatedLayout: widget.layoutType);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.client.sessionController.dispose();
  }

  Widget userLayout(String? layoutType, String? baseUrl) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: layoutType == "floating"
          ? Stack(
              children: [
                FloatingLayout(
                  client: widget.client,
                  disabledVideoWidget: widget.disabledVideoWidget,
                  floatingLayoutContainerHeight:
                      widget.floatingLayoutContainerHeight,
                  floatingLayoutContainerWidth:
                      widget.floatingLayoutContainerWidth,
                  floatingLayoutMainViewPadding:
                      widget.floatingLayoutMainViewPadding,
                  floatingLayoutSubViewPadding:
                      widget.floatingLayoutSubViewPadding,
                  showAVState: widget.showAVState,
                  showNumberOfUsers: widget.showNumberOfUsers,
                  videoRenderMode: widget.videoRenderMode,
                ),
                channelBar(baseUrl),
              ],
            )
          : Stack(
              children: [
                GridLayout(
                  client: widget.client,
                  showNumberOfUsers: widget.showNumberOfUsers,
                  disabledVideoWidget: widget.disabledVideoWidget,
                  videoRenderMode: widget.videoRenderMode,
                ),
                channelBar(baseUrl),
              ],
            ),
      onTap: () {
        widget.client.sessionController.toggleVisible();
      },
    );
  }

  Widget channelBar(String? baseUrl) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget
                    .client.sessionController.value.connectionData!.channelName
                    .toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  String tempTokenString = widget.client.sessionController.value
                              .connectionData!.tempToken ==
                          null
                      ? ''
                      : '&tempToken=${widget.client.sessionController.value.connectionData!.tempToken}';
                  String tokenUrlString = widget.client.sessionController.value
                              .connectionData!.tokenUrl ==
                          null
                      ? ''
                      : '&tokenUrl=${widget.client.sessionController.value.connectionData!.tokenUrl}';
                  String layoutTypeString =
                      widget.client.sessionController.value.layoutType ==
                              Layout.floating
                          ? '&layoutType=floating'
                          : '&layoutType=grid';
                  Share.share(
                      'Please join my channel: "${widget.client.sessionController.value.connectionData!.channelName}" using this link: ${widget.client.deepLinkBaseUrl}/channelName=${widget.client.sessionController.value.connectionData!.channelName}' +
                          tempTokenString +
                          tokenUrlString +
                          layoutTypeString);
                },
                child: Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late String appId;
    late String channelName;
    String? tempToken;
    String? tokenUrl;
    // TODO: List<AreaCode>? areaCodes;
    String? baseUrl;
    String? layoutType = "grid";
    Future<void> updateAgoraConnectionDataConfig(Object? link) async {
      if (link != '') {
        StreamSubscription<Uri?> subscription =
            uriLinkStream.listen((Uri? uri) async {
          print('uri: $uri');
          baseUrl = uri?.origin;

          uri?.queryParametersAll.forEach((key, value) {
            print('params');
            print('$key: ${value[0]}');
            if (key == 'channelName') {
              channelName = value[0];
              print('Channe Name: $channelName');
            } else if (key == 'tempToken') {
              tempToken = value[0];
              print('Temp Token: $tempToken');
            } else if (key == 'tokenUrl') {
              tokenUrl = value[0];
              print('Token Url: $tokenUrl');
            } else if (key == "layoutTpype") {
              layoutType = value[0];
              print("layoutType: $layoutType");
            }
          });
        });

        await subscription.asFuture();
        final response = await http.get(
          Uri.parse(
            '$baseUrl/.well-known/assetlinks.json',
          ),
        );
        if (response.statusCode == 200) {
          final responseJson = jsonDecode(response.body);
          appId = responseJson[0]['appId'];
        } else {
          print('response.statusCode: ${response.statusCode}');
        }
        await widget.client.sessionController.updateAgoraConnectionData(
          appId: appId,
          channelName: channelName,
          tokenUrl: tokenUrl,
          tempToken: tempToken,
        );
        await subscription.cancel();
      }
    }

    return StreamBuilder(
        stream: linkStream,
        builder: (context, streamSnapshot) {
          final link = streamSnapshot.data ?? '';
          updateAgoraConnectionDataConfig(link);
          if (link != '') {
            return userLayout(layoutType, baseUrl!);
          }
          return FutureBuilder(
              future: getInitialLink(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final link = snapshot.data ?? '';
                updateAgoraConnectionDataConfig(link);
                return userLayout(layoutType, baseUrl);
              });
        });
  }
}
