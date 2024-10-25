import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/media_device_context.dart';
import '../../../context/room_context.dart';

class MediaDeviceContextBuilder extends StatelessWidget {
  const MediaDeviceContextBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, RoomContext roomContext,
      MediaDeviceContext mediaDeviceContext) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) => ChangeNotifierProvider(
        create: (_) => MediaDeviceContext(roomCtx: roomCtx),
        child: Consumer<MediaDeviceContext>(
          builder: (context, mediaDeviceCtx, child) =>
              builder(context, roomCtx, mediaDeviceCtx),
        ),
      ),
    );
  }
}
