import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class MicrophoneSelectButton extends StatelessWidget {
  const MicrophoneSelectButton({super.key});

  void _disableAudio(roomCtx) async {
    await roomCtx.disableMicrophone();
  }

  void _enableAudio(roomCtx) async {
    await roomCtx.enableMicrophone();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, enabled) => roomCtx.isMicrophoneEnabled,
        builder: (context, enabled, child) => Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                color: enabled ? Colors.grey : Colors.grey.withOpacity(0.6)),
            child: GestureDetector(
              onTap: () =>
                  enabled ? _disableAudio(roomCtx) : _enableAudio(roomCtx),
              child: Row(
                children: [
                  Icon(enabled ? Icons.mic : Icons.mic_off),
                  const SizedBox(width: 4.0),
                  const Text('Microphone'),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.withOpacity(0.6)),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'audio-settings',
                    child: Text('Audio Settings'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'audio-devices',
                    child: Text('Audio Devices'),
                  ),
                ];
              },
            ),
          ),
        ]),
      );
    });
  }
}
