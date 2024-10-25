import 'package:flutter/material.dart';

import '../../builder/room/media_device_select_button.dart';
import 'media_device_select_button.dart';

class CameraSelectButton extends StatelessWidget {
  const CameraSelectButton({
    super.key,
    this.showLabels = false,
  });

  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return MediaDeviceSelectButton(
      builder: (context, roomCtx, deviceCtx) => MediaDeviceSelectWidget(
        title: 'Camera',
        iconOn: Icons.videocam,
        iconOff: Icons.videocam_off,
        deviceList: deviceCtx.videoInputs ?? [],
        selectedDeviceId: deviceCtx.selectedVideoInputDeviceId,
        deviceIsOpened: deviceCtx.cameraOpened,
        onSelect: (device) => deviceCtx.selectVideoInput(device),
        onToggle: (enabled) =>
            enabled ? deviceCtx.enableCamera() : deviceCtx.disableCamera(),
        showLabel: showLabels,
      ),
    );
  }
}
