import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:agora_uikit/src/agora_client.dart';
import 'package:agora_uikit/src/layout/widgets/network_state.dart';

class AgoraPreCallViewer extends StatefulWidget {
  final AgoraClient client;

  /// Use this to show/hide network state from the pre-call screen. This is enabled by default.
  final bool showNetworkState;

  /// Use this button to add navigation to the call screen. You can also add any other function you want to run before joining the channel.
  final Function()? joinCallButton;

  /// Use this to style the Join Call button as per your liking while still keeping the default functionality.
  final Widget? joinCallButtonWidget;

  const AgoraPreCallViewer({
    Key? key,
    required this.client,
    this.showNetworkState = true,
    required this.joinCallButton,
    this.joinCallButtonWidget,
  }) : super(key: key);

  @override
  State<AgoraPreCallViewer> createState() => AgoraPreCallViewerState();
}

class AgoraPreCallViewerState extends State<AgoraPreCallViewer> {
  Widget _getLocalViews() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: widget.client.sessionController.value.engine!,
        canvas: VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: widget.client.isInitialized
                          ? Column(
                              children: [
                                _videoView(_getLocalViews()),
                              ],
                            )
                          : Text('Connecting your camera...'),
                    ),
                    widget.showNetworkState
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: NetworkState(
                                qualityType: widget
                                    .client.sessionController.value.qualityType,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              widget.joinCallButtonWidget != null
                  ? RawMaterialButton(
                      child: widget.joinCallButtonWidget,
                      onPressed: (() {
                        widget.client.sessionController
                            .updatePreCallScreen(addPreCallScreen: false);
                        widget.joinCallButton!();
                      }),
                    )
                  : RawMaterialButton(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Join Call',
                        style: TextStyle(color: Colors.white),
                      ),
                      elevation: 5,
                      fillColor: Colors.blue,
                      onPressed: (() {
                        widget.client.sessionController
                            .updatePreCallScreen(addPreCallScreen: false);
                        widget.joinCallButton!();
                      }),
                    )
            ],
          ),
        );
      },
    );
  }
}
