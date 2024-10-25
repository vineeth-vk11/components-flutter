import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';

class CameraSwitchButton extends StatelessWidget {
  const CameraSwitchButton({
    super.key,
    this.currentPosition = CameraPosition.front,
    this.onToggle,
    this.disabled = false,
  });

  final CameraPosition? currentPosition;
  final Function(CameraPosition position)? onToggle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.6)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)))),
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(12),
        ),
      ),
      onPressed: () => onToggle?.call(currentPosition == CameraPosition.front
          ? CameraPosition.back
          : CameraPosition.front),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currentPosition == CameraPosition.back
              ? Icons.video_camera_back
              : Icons.video_camera_front),
        ],
      ),
    );
  }
}
