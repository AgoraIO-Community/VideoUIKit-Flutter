import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class NetworkState extends StatefulWidget {
  final QualityType qualityType;
  const NetworkState({
    Key? key,
    required this.qualityType,
  }) : super(key: key);

  @override
  State<NetworkState> createState() => _NetworkStateState();
}

class _NetworkStateState extends State<NetworkState> {
  Iterable<NetworkIcon> networkIcon = [
    NetworkIcon(
        qualityType: QualityType.qualityExcellent,
        iconData: Icons.network_wifi_rounded,
        colors: Colors.green),
    NetworkIcon(
        qualityType: QualityType.qualityGood,
        iconData: Icons.network_wifi_3_bar_rounded,
        colors: Colors.green),
    NetworkIcon(
        qualityType: QualityType.qualityBad,
        iconData: Icons.network_wifi_3_bar_rounded,
        colors: Colors.green),
    NetworkIcon(
        qualityType: QualityType.qualityPoor,
        iconData: Icons.network_wifi_2_bar_rounded,
        colors: Colors.yellow),
    NetworkIcon(
        qualityType: QualityType.qualityVbad,
        iconData: Icons.network_wifi_1_bar_rounded,
        colors: Colors.red),
    NetworkIcon(
        qualityType: QualityType.qualityDown,
        iconData: Icons.network_check_rounded,
        colors: Colors.grey),
    NetworkIcon(
        qualityType: QualityType.qualityDetecting,
        iconData: Icons.network_check_rounded,
        colors: Colors.grey),
    NetworkIcon(
        qualityType: QualityType.qualityUnknown,
        iconData: Icons.network_check_rounded,
        colors: Colors.grey),
    NetworkIcon(
        qualityType: QualityType.qualityUnsupported,
        iconData: Icons.network_check_rounded,
        colors: Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    NetworkIcon icon = networkIcon
        .where((element) => element.qualityType == widget.qualityType)
        .single;
    return Icon(
      icon.iconData,
      color: icon.colors,
    );
  }
}

class NetworkIcon {
  QualityType qualityType;
  IconData iconData;
  MaterialColor colors;

  NetworkIcon({
    required this.qualityType,
    required this.iconData,
    required this.colors,
  });
}
