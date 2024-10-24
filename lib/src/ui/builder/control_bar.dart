import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/room_context.dart';
import '../buttons/audio_output_select_button.dart';
import '../buttons/camera_select_button.dart';
import '../buttons/chat_toggle.dart';
import '../buttons/disconnect_button.dart';
import '../buttons/microphone_select_button.dart';
import '../buttons/screenshare_toggle.dart';
import 'media_device.dart';

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
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) {
          return MediaDevices(
            builder: (context, mediaDeviceCtx) => Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                if (microphone) MicrophoneSelectButton(showLabel: showLabels),
                if (lkPlatformIsDesktop() && audioOutput)
                  AudioOutputSelectButton(showLabel: showLabels),
                if (camera) CameraSelectButton(showLabel: showLabels),
                if (screenShare) ScreenShareToggle(showLabel: showLabels),
                if (chat) ChatToggle(showLabel: showLabels),
                if (leave) const DisconnectButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
