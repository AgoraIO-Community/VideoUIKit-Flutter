import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/src/layout/floating_layout.dart';
import 'package:agora_uikit/src/layout/grid_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  final EdgeInsets? floatingLayoutMainViewPadding;

  /// Padding of the secondary user present in the list.
  final EdgeInsets? floatingLayoutSubViewPadding;

  /// Widget that will be displayed when the local or remote user has disabled it's video.
  final Widget? disabledVideoWidget;

  /// Display the camera and microphone status of a user. This feature is only available in the [Layout.floating]
  final bool showAVState;

  /// Display the total number of users in a channel.
  final bool showNumberOfUsers;

  const AgoraVideoViewer({
    Key? key,
    required this.client,
    this.layoutType = Layout.grid,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.floatingLayoutMainViewPadding,
    this.floatingLayoutSubViewPadding,
    this.disabledVideoWidget,
    this.showAVState = false,
    this.showNumberOfUsers = false,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  @override
  void dispose() {
    super.dispose();
    widget.client.sessionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: widget.layoutType == Layout.floating
          ? FloatingLayout(
              client: widget.client,
              disabledVideoWidget: widget.disabledVideoWidget,
              floatingLayoutContainerHeight:
                  widget.floatingLayoutContainerHeight,
              floatingLayoutContainerWidth: widget.floatingLayoutContainerWidth,
              floatingLayoutMainViewPadding:
                  widget.floatingLayoutMainViewPadding,
              floatingLayoutSubViewPadding: widget.floatingLayoutSubViewPadding,
              showAVState: widget.showAVState,
              showNumberOfUsers: widget.showNumberOfUsers,
            )
          : GridLayout(
              client: widget.client,
              showNumberOfUsers: widget.showNumberOfUsers,
            ),
      onTap: () {
        widget.client.sessionController.toggleVisible();
      },
    );
  }
}
