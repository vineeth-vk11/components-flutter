import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/room_context.dart';
import '../../debug/logger.dart';

class RoomMetadata extends StatelessWidget {
  const RoomMetadata({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, String? metadata) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      Debug.log('====>        RoomMetadata for ${roomCtx.roomMetadata}');
      return Selector<ParticipantContext, String?>(
        selector: (context, metadata) => roomCtx.roomMetadata,
        builder: (context, metadata, child) {
          return builder(context, metadata);
        },
      );
    });
  }
}
