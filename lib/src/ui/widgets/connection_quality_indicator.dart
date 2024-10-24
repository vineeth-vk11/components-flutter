import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';

class ConnectionQualityIndicatorWidget extends StatelessWidget {
  final ConnectionQuality connectionQuality;

  ConnectionQualityIndicatorWidget({required this.connectionQuality});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Icon(
        connectionQuality == ConnectionQuality.poor
            ? Icons.wifi_off_outlined
            : Icons.wifi,
        color: {
          ConnectionQuality.excellent: Colors.green,
          ConnectionQuality.good: Colors.orange,
          ConnectionQuality.poor: Colors.red,
          ConnectionQuality.lost: Colors.grey,
          ConnectionQuality.unknown: Colors.grey,
        }[connectionQuality],
        size: 20,
      ),
    );
  }
}
