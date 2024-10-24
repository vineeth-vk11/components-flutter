import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/media_device_context.dart';
import '../../context/room_context.dart';

typedef MediaDevicesBuilder = Widget Function(
    BuildContext context, MediaDeviceContext mediaDeviceContext);

class MediaDevices extends StatelessWidget {
  const MediaDevices({super.key, required this.builder});

  final MediaDevicesBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) => ChangeNotifierProvider(
        create: (_) => MediaDeviceContext(roomCtx: roomCtx),
        child: Consumer<MediaDeviceContext>(
          builder: (context, mediaDeviceCtx, child) =>
              builder(context, mediaDeviceCtx),
        ),
      ),
    );
  }
}
