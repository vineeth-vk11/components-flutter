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
        vertical: 15,
        horizontal: 15,
      ),
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              if (microphone) const MicrophoneToggleButton(),
              if (camera) const CameraToggleButton(),
              if (screenShare) const ScreenShareToggleButton(),
              if (leave) const DisconnectButton(),
            ],
          );
        },
      ),
    );
  }
}
