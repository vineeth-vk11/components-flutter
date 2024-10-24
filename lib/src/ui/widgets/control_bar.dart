import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';

import '../builder/chat_toggle.dart';
import '../builder/disconnect_button.dart';
import '../builder/media_device_select_button.dart';
import '../builder/screenshare_toggle.dart';
import 'chat_toggle.dart';
import 'disconnect_button.dart';
import 'media_device_select_button.dart';
import 'screenshare_toggle.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    this.microphone = true,
    this.audioOutput = true,
    this.camera = true,
    this.chat = true,
    this.screenShare = true,
    this.leave = true,
    this.settings = true,
    this.showLabels = false,
  });

  final bool microphone;
  final bool audioOutput;
  final bool camera;
  final bool chat;
  final bool screenShare;
  final bool leave;
  final bool settings;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          if (microphone)
            MediaDeviceSelectButton(
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
            ),
          if (audioOutput &&
              (lkPlatformIsDesktop() || lkPlatformIs(PlatformType.web)))
            MediaDeviceSelectButton(
              builder: (context, roomCtx, deviceCtx) => MediaDeviceSelectWidget(
                title: 'Audio Output',
                iconOn: Icons.volume_up,
                iconOff: Icons.volume_off,
                deviceList: deviceCtx.audioOutputs ?? [],
                selectedDeviceId: deviceCtx.selectedAudioOutputDeviceId,
                deviceIsOpened: false,
                toggleAvailable: false,
                defaultSelectable: true,
                onSelect: (device) => deviceCtx.selectAudioOutput(device),
                showLabel: showLabels,
              ),
            ),
          if (camera)
            MediaDeviceSelectButton(
              builder: (context, roomCtx, deviceCtx) => MediaDeviceSelectWidget(
                title: 'Camera',
                iconOn: Icons.videocam,
                iconOff: Icons.videocam_off,
                deviceList: deviceCtx.videoInputs ?? [],
                selectedDeviceId: deviceCtx.selectedVideoInputDeviceId,
                deviceIsOpened: deviceCtx.cameraOpened,
                onSelect: (device) => deviceCtx.selectVideoInput(device),
                onToggle: (enabled) => enabled
                    ? deviceCtx.enableCamera()
                    : deviceCtx.disableCamera(),
                showLabel: showLabels,
              ),
            ),
          if (screenShare)
            ScreenShareToggle(
              builder: (context, roomCtx, deviceCtx, screenShareEnabled) =>
                  ScreenShareToggleWidget(
                roomCtx: roomCtx,
                deviceCtx: deviceCtx,
                screenShareEnabled: screenShareEnabled,
                showLabel: showLabels,
              ),
            ),
          if (chat)
            ChatToggle(
              builder: (context, roomCtx, isChatEnabled) => ChatToggleWidget(
                isChatOpen: roomCtx.isChatEnabled,
                toggleChat: (enabled) =>
                    enabled ? roomCtx.enableChat() : roomCtx.disableChat(),
                showLabel: showLabels,
              ),
            ),
          if (leave)
            DisconnectButton(
              builder: (context, roomCtx, connected) => DisconnectButtonWidget(
                roomCtx: roomCtx,
                connected: connected,
                showLabel: showLabels,
              ),
            ),
        ],
      ),
    );
  }
}
