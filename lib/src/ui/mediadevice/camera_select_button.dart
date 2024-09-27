import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class CameraToggleButton extends StatelessWidget {
  const CameraToggleButton({super.key});

  void _disableCamera(roomCtx) async {
    await roomCtx.disableCamera();
  }

  void _enableCamera(roomCtx) async {
    await roomCtx.enableCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, enabled) => roomCtx.isCameraEnabled,
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
                  enabled ? _disableCamera(roomCtx) : _enableCamera(roomCtx),
              child: Row(
                children: [
                  Icon(enabled ? Icons.videocam : Icons.videocam_off),
                  const SizedBox(width: 4.0),
                  const Text('Camera'),
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
