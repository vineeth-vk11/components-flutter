import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/media_device_context.dart';
import '../../../context/room_context.dart';

class SpeakerSwitch extends StatelessWidget {
  const SpeakerSwitch({
    super.key,
    required this.builder,
  });

  final Function(BuildContext context, RoomContext roomCtx,
      MediaDeviceContext deviceCtx, bool? isSpeakerOn) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Consumer<MediaDeviceContext>(
          builder: (context, deviceCtx, child) {
            return Selector<MediaDeviceContext, bool?>(
              selector: (context, isSpeakerOn) => deviceCtx.isSpeakerOn,
              builder: (context, isSpeakerOn, child) => builder(
                context,
                roomCtx,
                deviceCtx,
                isSpeakerOn,
              ),
            );
          },
        );
      },
    );
  }
}
