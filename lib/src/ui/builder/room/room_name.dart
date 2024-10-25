import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/participant_context.dart';
import '../../../context/room_context.dart';
import '../../../debug/logger.dart';

class RoomName extends StatelessWidget {
  const RoomName({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, String? roomName) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        Debug.log('====>        RoomName for ${roomCtx.roomName}');
        return Selector<ParticipantContext, String?>(
          selector: (context, name) => roomCtx.roomName,
          builder: (context, name, child) {
            return builder(context, name);
          },
        );
      },
    );
  }
}
