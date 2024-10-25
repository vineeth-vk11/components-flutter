import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/media_device_context.dart';
import '../../../context/room_context.dart';

class MediaDeviceSelectButton extends StatelessWidget {
  const MediaDeviceSelectButton({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    RoomContext roomCtx,
    MediaDeviceContext deviceCtx,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) => Consumer<MediaDeviceContext>(
        builder: (context, deviceCtx, child) =>
            builder(context, roomCtx, deviceCtx),
      ),
    );
  }
}
