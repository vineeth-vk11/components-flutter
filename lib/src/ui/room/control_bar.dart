import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livekit_components/livekit_components.dart';

class ControlBar extends StatelessWidget {
  const ControlBar(
      {super.key,
      this.microphone = true,
      this.camera = true,
      this.chat = true,
      this.screenShare = true,
      this.leave = true,
      this.settings = true});

  final bool microphone;
  final bool camera;
  final bool chat;
  final bool screenShare;
  final bool leave;
  final bool settings;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (microphone) const MicrophoneToggleButton(),
              if (camera) const CameraToggleButton(),
              if (screenShare) const ScreenShareToggleButton(),
              if (chat) const ChatToggleButton(),
              if (leave) const DisconnectButton(),
            ],
          );
        },
      ),
    );
  }
}
