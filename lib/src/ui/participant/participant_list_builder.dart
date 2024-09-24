import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../livekit_components.dart';

class ParticipantListBuilder extends StatelessWidget {
  const ParticipantListBuilder({super.key, required this.builder});
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, List<Participant>>(
        selector: (context, participants) => roomCtx.participants,
        builder: (context, participants, child) => GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.0),
          children: participants.map(
            (p) {
              var ctx = ParticipantContext(p);
              return ChangeNotifierProvider(
                  create: (_) => ctx, child: builder(context));
            },
          ).toList(),
        ),
      );
    });
  }
}
