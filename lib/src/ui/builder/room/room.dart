import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/room_context.dart';
import 'media_device.dart';

class LivekitRoom extends StatelessWidget {
  const LivekitRoom(
      {super.key, required this.roomContext, required this.builder});

  final RoomContext roomContext;
  final Widget Function(BuildContext context, RoomContext roomCtx) builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => roomContext,
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) => MediaDeviceContextBuilder(
          builder: (context, roomCtx, mediaDeviceCtx) =>
              builder(context, roomCtx),
        ),
      ),
    );
  }
}
