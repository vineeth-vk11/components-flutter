import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../livekit_components.dart';

typedef ParticipantListWidgetBuilder = Widget Function(
    BuildContext context, List<Participant>);

class ParticipantListBuilder extends StatelessWidget {
  const ParticipantListBuilder({super.key, required this.builder});
  final ParticipantListWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    print('ParticipantListBuilder build');
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Selector<RoomContext, List<Participant>>(
          selector: (context, participants) => roomCtx.participants,
          builder: (context, participants, child) =>
              builder(context, participants),
        );
      },
    );
  }
}
