import 'package:flutter/material.dart';

class RecordIcon extends StatefulWidget {
  RecordIcon({Key? key}) : super(key: key);

  @override
  _RecordIconState createState() => _RecordIconState();
}

class _RecordIconState extends State<RecordIcon> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(3),
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REC',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
