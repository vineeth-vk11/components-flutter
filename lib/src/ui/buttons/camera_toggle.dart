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
          builder: (context, enabled, child) => IconButton(
                onPressed: () =>
                    enabled ? _disableCamera(roomCtx) : _enableCamera(roomCtx),
                icon: Icon(enabled ? Icons.videocam_off : Icons.videocam),
                tooltip: enabled ? 'mute cam' : 'unmute cam',
              ));
    });
  }
}
