import 'package:flutter/material.dart';

import '../../builder/room/media_device_select_button.dart';
import 'media_device_select_button.dart';

class MicrophoneSelectButton extends StatelessWidget {
  const MicrophoneSelectButton({
    super.key,
    this.showLabels = false,
  });

  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return MediaDeviceSelectButton(
      builder: (context, roomCtx, deviceCtx) => MediaDeviceSelectWidget(
        title: 'Microphone',
        iconOn: Icons.mic,
        iconOff: Icons.mic_off,
        deviceList: deviceCtx.audioInputs ?? [],
        selectedDeviceId: deviceCtx.selectedAudioInputDeviceId,
        deviceIsOpened: deviceCtx.microphoneOpened,
        onSelect: (device) => deviceCtx.selectAudioInput(device),
        onToggle: (enabled) => enabled
            ? deviceCtx.enableMicrophone()
            : deviceCtx.disableMicrophone(),
        showLabel: showLabels,
      ),
    );
  }
}
