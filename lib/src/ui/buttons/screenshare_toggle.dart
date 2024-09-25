import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class ScreenShareToggleButton extends StatelessWidget {
  const ScreenShareToggleButton({super.key});

  void _disableScreenShare(RoomContext roomCtx) async {
    await roomCtx.disableScreenShare();
  }

  void _enableScreenShare(context, RoomContext roomCtx) async {
    await roomCtx.enableScreenShare(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
          selector: (context, enabled) => roomCtx.isScreenShareEnabled,
          builder: (context, enabled, child) => IconButton(
                onPressed: () => enabled
                    ? _disableScreenShare(roomCtx)
                    : _enableScreenShare(context, roomCtx),
                icon: const Icon(Icons.screen_share),
                tooltip:
                    enabled ? 'Stop screen sharing' : 'Start screen sharing',
              ));
    });
  }
}
