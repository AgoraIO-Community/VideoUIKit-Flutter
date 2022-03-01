import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:agora_uikit/src/layout/widgets/host_controls.dart';
import 'package:agora_uikit/src/layout/widgets/number_of_users.dart';
import 'package:agora_uikit/src/layout/widgets/user_av_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class FloatingLayout extends StatefulWidget {
  final AgoraClient client;

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
  final bool? showAVState;

  /// Display the host controls. This feature is only available in the [Layout.floating]
  final bool? enableHostControl;

  /// Display the total number of users in a channel.
  final bool? showNumberOfUsers;

  /// Render mode for local and remote video
  final VideoRenderMode? videoRenderMode;

  const FloatingLayout({
    Key? key,
    required this.client,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.floatingLayoutMainViewPadding = const EdgeInsets.fromLTRB(3, 0, 3, 3),
    this.floatingLayoutSubViewPadding = const EdgeInsets.fromLTRB(3, 3, 0, 3),
    this.disabledVideoWidget = const DisabledVideoWidget(),
    this.showAVState = false,
    this.enableHostControl = false,
    this.showNumberOfUsers,
    this.videoRenderMode,
  }) : super(key: key);

  @override
  _FloatingLayoutState createState() => _FloatingLayoutState();
}

class _FloatingLayoutState extends State<FloatingLayout> {
  Widget _getLocalViews() {
    return rtc_local_view.SurfaceView(
      renderMode: widget.videoRenderMode,
    );
  }

  Widget _getRemoteViews(int uid) {
    return rtc_remote_view.SurfaceView(
      channelId:
          widget.client.sessionController.value.connectionData!.channelName,
      uid: uid,
      renderMode: widget.videoRenderMode,
    );
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _viewFloat() {
    return widget.client.sessionController.value.users.isNotEmpty
        ? Column(
            children: [
              Container(
                height: widget.floatingLayoutContainerHeight ??
                    MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.client.sessionController.value.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return widget.client.sessionController.value.users[index]
                                .uid !=
                            widget.client.sessionController.value.mainAgoraUser
                                .uid
                        ? Padding(
                            key: Key('$index'),
                            padding: widget.floatingLayoutSubViewPadding,
                            child: Container(
                              width: widget.floatingLayoutContainerWidth ??
                                  MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: [
                                  widget.client.sessionController.value
                                              .users[index].uid ==
                                          widget.client.sessionController.value
                                              .localUid
                                      ? Expanded(
                                          child: Container(
                                            color: Colors.black,
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Local User',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                !widget
                                                        .client
                                                        .sessionController
                                                        .value
                                                        .isLocalVideoDisabled
                                                    ? Column(
                                                        children: [
                                                          _videoView(
                                                              _getLocalViews()),
                                                        ],
                                                      )
                                                    : widget
                                                        .disabledVideoWidget,
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          widget.client
                                                              .sessionController
                                                              .swapUser(
                                                                  index: index);
                                                        },
                                                        child: Container(
                                                          height: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Image.network(
                                                            'https://i.ibb.co/JrJ7R3w/unpin-icon.png',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                widget.showAVState!
                                                    ? UserAVStateWidget(
                                                        videoDisabled: widget
                                                            .client
                                                            .sessionController
                                                            .value
                                                            .isLocalVideoDisabled,
                                                        muted: widget
                                                            .client
                                                            .sessionController
                                                            .value
                                                            .isLocalUserMuted,
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : widget.client.sessionController.value
                                              .users[index].videoDisabled
                                          ? Expanded(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.black,
                                                  ),
                                                  widget.disabledVideoWidget,
                                                  Positioned.fill(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                widget.client
                                                                    .sessionController
                                                                    .swapUser(
                                                                        index:
                                                                            index);
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .push_pin_rounded,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              widget.enableHostControl ==
                                                                          null ||
                                                                      false
                                                                  ? Container()
                                                                  : HostControls(
                                                                      client: widget
                                                                          .client,
                                                                      videoDisabled: widget
                                                                          .client
                                                                          .sessionController
                                                                          .value
                                                                          .users[
                                                                              index]
                                                                          .videoDisabled,
                                                                      muted: widget
                                                                          .client
                                                                          .sessionController
                                                                          .value
                                                                          .users[
                                                                              index]
                                                                          .muted,
                                                                      index:
                                                                          index,
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                      child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                  )),
                                                  widget.showAVState!
                                                      ? UserAVStateWidget(
                                                          videoDisabled: widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .videoDisabled,
                                                          muted: widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .muted)
                                                      : Container(),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      _videoView(
                                                        _getRemoteViews(
                                                          widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .uid,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned.fill(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                widget.client
                                                                    .sessionController
                                                                    .swapUser(
                                                                        index:
                                                                            index);
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .push_pin_rounded,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              widget.enableHostControl ==
                                                                          null ||
                                                                      false
                                                                  ? Container()
                                                                  : HostControls(
                                                                      client: widget
                                                                          .client,
                                                                      videoDisabled: widget
                                                                          .client
                                                                          .sessionController
                                                                          .value
                                                                          .users[
                                                                              index]
                                                                          .videoDisabled,
                                                                      muted: widget
                                                                          .client
                                                                          .sessionController
                                                                          .value
                                                                          .users[
                                                                              index]
                                                                          .muted,
                                                                      index:
                                                                          index,
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  widget.showAVState!
                                                      ? UserAVStateWidget(
                                                          videoDisabled: widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .videoDisabled,
                                                          muted: widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .muted)
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                ],
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
              ),
              widget.client.sessionController.value.mainAgoraUser.uid !=
                      widget.client.sessionController.value.localUid
                  ? Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: widget.floatingLayoutMainViewPadding,
                            child: Column(
                              children: [
                                _videoView(_getRemoteViews(widget.client
                                    .sessionController.value.mainAgoraUser.uid))
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: widget.enableHostControl == null || false
                                ? Container()
                                : HostControls(
                                    client: widget.client,
                                    videoDisabled: widget
                                        .client
                                        .sessionController
                                        .value
                                        .mainAgoraUser
                                        .videoDisabled,
                                    muted: widget.client.sessionController.value
                                        .mainAgoraUser.muted,
                                    index: widget
                                        .client.sessionController.value.users
                                        .indexWhere(
                                      (element) =>
                                          element.uid ==
                                          widget.client.sessionController.value
                                              .mainAgoraUser.uid,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Container(
                        padding: widget.floatingLayoutMainViewPadding,
                        child: widget.client.sessionController.value
                                .isLocalVideoDisabled
                            ? widget.disabledVideoWidget
                            : Stack(
                                children: [
                                  Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        'Local User',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      _videoView(_getLocalViews()),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
            ],
          )
        : widget.client.sessionController.value.clientRole ==
                ClientRole.Broadcaster
            ? widget.client.sessionController.value.isLocalVideoDisabled
                ? Column(
                    children: [
                      Expanded(child: widget.disabledVideoWidget),
                    ],
                  )
                : Container(
                    child: Column(
                      children: <Widget>[_videoView(_getLocalViews())],
                    ),
                  )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Waiting for the host to join.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (context, counter, widgetx) {
        return Center(
          child: Stack(
            children: [
              _viewFloat(),
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
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget
                                .client.sessionController.value.showMicMessage)
                              widget.client.sessionController.value
                                          .muteRequest ==
                                      MicState.muted
                                  ? Text("Please unmute your mic")
                                  : Text("Please mute your mic"),
                            if (widget.client.sessionController.value
                                .showCameraMessage)
                              widget.client.sessionController.value
                                          .cameraRequest ==
                                      CameraState.disabled
                                  ? Text("Please turn on your camera")
                                  : Text("Please turn off your camera"),
                            TextButton(
                              onPressed: () {
                                widget.client.sessionController.value
                                            .showMicMessage &&
                                        !widget.client.sessionController.value
                                            .showCameraMessage
                                    ? widget.client.sessionController
                                        .toggleMute()
                                    : widget.client.sessionController
                                        .toggleCamera();
                                widget.client.sessionController.value = widget
                                    .client.sessionController.value
                                    .copyWith(
                                  displaySnackbar: false,
                                  showMicMessage: false,
                                  showCameraMessage: false,
                                );
                              },
                              child: widget.client.sessionController.value
                                      .showMicMessage
                                  ? widget.client.sessionController.value
                                              .muteRequest ==
                                          MicState.muted
                                      ? Text(
                                          "Unmute",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      : Text(
                                          "Mute",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                  : widget.client.sessionController.value
                                              .cameraRequest ==
                                          CameraState.disabled
                                      ? Text(
                                          "Enable",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      : Text(
                                          "Disable",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                            )
                          ],
                        )),
                    visible:
                        widget.client.sessionController.value.displaySnackbar,
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
