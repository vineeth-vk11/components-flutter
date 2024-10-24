import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/media_device_context.dart';
import '../../context/room_context.dart';

class ScreenShareToggle extends StatelessWidget {
  const ScreenShareToggle({
    super.key,
    required this.builder,
  });

  final Function(BuildContext context, RoomContext roomCtx,
      MediaDeviceContext deviceCtx, bool screenShareEnabled) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Consumer<MediaDeviceContext>(
          builder: (context, deviceCtx, child) {
            return Selector<MediaDeviceContext, bool>(
              selector: (context, screenShareEnabled) =>
                  deviceCtx.isScreenShareEnabled,
              builder: (context, screenShareEnabled, child) => builder(
                context,
                roomCtx,
                deviceCtx,
                screenShareEnabled,
              ),
            );
          },
        );
      },
    );
  }
}
