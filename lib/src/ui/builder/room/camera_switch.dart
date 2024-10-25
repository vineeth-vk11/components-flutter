import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../context/media_device_context.dart';
import '../../../context/room_context.dart';

class CameraSwitch extends StatelessWidget {
  const CameraSwitch({
    super.key,
    required this.builder,
  });

  final Function(BuildContext context, RoomContext roomCtx,
      MediaDeviceContext deviceCtx, CameraPosition? position) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Consumer<MediaDeviceContext>(
          builder: (context, deviceCtx, child) {
            return Selector<MediaDeviceContext, CameraPosition?>(
              selector: (context, position) => deviceCtx.currentPosition,
              builder: (context, position, child) => builder(
                context,
                roomCtx,
                deviceCtx,
                position,
              ),
            );
          },
        );
      },
    );
  }
}
