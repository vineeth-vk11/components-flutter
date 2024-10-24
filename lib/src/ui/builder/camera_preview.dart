import 'package:flutter/widgets.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/room_context.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, LocalVideoTrack? videoTrack)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) =>
          Selector<RoomContext, LocalVideoTrack?>(
        selector: (context, track) => roomCtx.localVideoTrack,
        builder: (context, track, child) => builder(context, track),
      ),
    );
  }
}
