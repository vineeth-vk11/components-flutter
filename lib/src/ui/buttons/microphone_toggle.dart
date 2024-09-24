import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/room.dart';

class MicrophoneToggleButton extends StatelessWidget {
  const MicrophoneToggleButton({super.key});

  void _disableAudio(context) {
    final roomCtx = Provider.of<RoomContext>(context, listen: false);
    roomCtx.disableMicrophone();
  }

  void _enableAudio(context) {
    final roomCtx = Provider.of<RoomContext>(context, listen: false);
    roomCtx.enableMicrophone();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
          selector: (context, enabled) => roomCtx.isMicrophoneEnabled,
          builder: (context, enabled, child) => IconButton(
                onPressed: () =>
                    enabled ? _disableAudio(context) : _enableAudio(context),
                icon: Icon(enabled ? Icons.mic_off : Icons.mic),
                tooltip: enabled ? 'mute audio' : 'unmute audio',
              ));
    });
  }
}
