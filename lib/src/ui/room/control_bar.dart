import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../buttons/audio_output_select_button.dart';
import '../buttons/camera_select_button.dart';
import '../buttons/chat_toggle.dart';
import '../buttons/disconnect_button.dart';
import '../buttons/microphone_select_button.dart';
import '../buttons/screenshare_toggle.dart';

class ControlBar extends StatelessWidget {
  const ControlBar(
      {super.key,
      this.microphone = true,
      this.audioOutput = true,
      this.camera = true,
      this.chat = true,
      this.screenShare = true,
      this.leave = true,
      this.settings = true});

  final bool microphone;
  final bool audioOutput;
  final bool camera;
  final bool chat;
  final bool screenShare;
  final bool leave;
  final bool settings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              if (microphone) const MicrophoneSelectButton(),
              if (lkPlatformIsDesktop() && audioOutput)
                const AudioOutputSelectButton(),
              if (camera) const CameraSelectButton(),
              if (screenShare) const ScreenShareToggle(),
              if (chat) const ChatToggle(),
              if (leave) const DisconnectButton(),
            ],
          );
        },
      ),
    );
  }
}
