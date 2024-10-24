import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/room_context.dart';
import '../../debug/logger.dart';

class RoomParticipants extends StatelessWidget {
  const RoomParticipants({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, List<Participant> participants)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        Debug.log('====>        RoomParticipants for ${roomCtx.roomName}');
        return Selector<ParticipantContext, List<Participant>>(
          selector: (context, participants) => roomCtx.participants,
          builder: (context, participants, child) {
            return builder(context, participants);
          },
        );
      },
    );
  }
}
