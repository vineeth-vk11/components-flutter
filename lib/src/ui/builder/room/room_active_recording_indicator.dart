import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/participant_context.dart';
import '../../../context/room_context.dart';
import '../../../debug/logger.dart';

class RoomActiveRecording extends StatelessWidget {
  const RoomActiveRecording({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool activeRecording) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      Debug.log(
          '====>        RoomActiveRecording for ${roomCtx.activeRecording}');
      return Selector<ParticipantContext, bool>(
        selector: (context, activeRecording) => roomCtx.activeRecording,
        builder: (context, activeRecording, child) {
          return builder(context, activeRecording);
        },
      );
    });
  }
}
