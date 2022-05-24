import 'package:flutter/material.dart';

/// Widget that is displayed when local/remote video is disabled.
class DisabledVideoWidget extends StatefulWidget {
  const DisabledVideoWidget({Key? key}) : super(key: key);

  @override
  State<DisabledVideoWidget> createState() => _DisabledVideoWidgetState();
}

class _DisabledVideoWidgetState extends State<DisabledVideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Image.network(
          'https://i.ibb.co/q5RysSV/image.png',
        ),
      ),
    );
  }
}
