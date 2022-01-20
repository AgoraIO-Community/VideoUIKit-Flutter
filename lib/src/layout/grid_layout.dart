import 'package:agora_uikit/models/agora_user.dart';
import 'package:agora_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:agora_uikit/src/layout/widgets/number_of_users.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class GridLayout extends StatefulWidget {
  final AgoraClient client;

  /// Display the total number of users in a channel.
  final bool? showNumberOfUsers;

  /// Widget that will be displayed when the local or remote user has disabled it's video.
  final Widget? disabledVideoWidget;

  /// Render mode for local and remote video
  final VideoRenderMode? videoRenderMode;

  const GridLayout({
    Key? key,
    required this.client,
    this.showNumberOfUsers,
    this.disabledVideoWidget = const DisabledVideoWidget(),
    this.videoRenderMode,
  }) : super(key: key);

  @override
  _GridLayoutState createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    widget.client.sessionController.value.isLocalVideoDisabled
        ? list.add(
            DisabledVideoStfWidget(
              disabledVideoWidget: widget.disabledVideoWidget,
            ),
          )
        : list.add(
            rtc_local_view.SurfaceView(
              zOrderMediaOverlay: true,
              renderMode: widget.videoRenderMode,
            ),
          );

    for (AgoraUser user in widget.client.sessionController.value.users) {
      user.videoDisabled
          ? list.add(
              DisabledVideoStfWidget(
                disabledVideoWidget: widget.disabledVideoWidget,
              ),
            )
          : list.add(
              rtc_remote_view.SurfaceView(
                channelId: widget
                    .client.sessionController.value.connectionData!.channelName,
                uid: user.uid,
                renderMode: widget.videoRenderMode,
              ),
            );
    }

    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _viewGrid() {
    final views = _getRenderViews();
    if (views.isEmpty) {
      return Expanded(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              'Waiting for the host to join',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    } else if (views.length == 1) {
      return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ),
      );
    } else if (views.length == 2) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow([views[0]]),
          _expandedVideoRow([views[1]])
        ],
      ));
    } else if (views.length > 2 && views.length % 2 == 0) {
      return Container(
        child: Column(
          children: [
            for (int i = 0; i < views.length; i = i + 2)
              _expandedVideoRow(
                views.sublist(i, i + 2),
              ),
          ],
        ),
      );
    } else if (views.length > 2 && views.length % 2 != 0) {
      return Container(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < views.length; i = i + 2)
              i == (views.length - 1)
                  ? _expandedVideoRow(views.sublist(i, i + 1))
                  : _expandedVideoRow(views.sublist(i, i + 2)),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (context, counter, widgetx) {
        return Center(
          child: Stack(
            children: [
              _viewGrid(),
              widget.showNumberOfUsers == null ||
                      widget.showNumberOfUsers == false
                  ? Container()
                  : Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: NumberOfUsers(
                          userCount: widget
                              .client.sessionController.value.users.length,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class DisabledVideoStfWidget extends StatefulWidget {
  final Widget? disabledVideoWidget;
  const DisabledVideoStfWidget({Key? key, this.disabledVideoWidget})
      : super(key: key);

  @override
  _DisabledVideoStfWidgetState createState() => _DisabledVideoStfWidgetState();
}

class _DisabledVideoStfWidgetState extends State<DisabledVideoStfWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.disabledVideoWidget!;
  }
}
