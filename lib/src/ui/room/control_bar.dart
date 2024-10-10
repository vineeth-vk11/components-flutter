import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livekit_components/livekit_components.dart';
import 'package:livekit_components/src/ui/buttons/leave_button.dart';

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
    return SizedBox(
      height: 80,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Consumer<RoomContext>(
            builder: (context, roomCtx, child) {
              return Wrap(
                runSpacing: 8,
                direction: Axis.vertical,
                children: [
                  if (microphone) const MicrophoneSelectButton(),
                  if (camera) const CameraSelectButton(),
                  if (screenShare) const ScreenShareToggle(),
                  if (chat) const ChatToggle(),
                  if (leave) const LeaveButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
