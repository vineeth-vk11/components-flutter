import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import 'package:provider/provider.dart';

import '../../../livekit_components.dart';

class ParticipantBuilder extends StatelessWidget {
  ParticipantBuilder({
    super.key,
    required Participant participant,
    required this.builder,
  }) : participantContext = ParticipantContext(participant);

  final WidgetBuilder builder;

  final ParticipantContext participantContext;

  @override
  Widget build(BuildContext context) {
    print(
        'ParticipantBuilder build ${participantContext.participant.identity}');
    return ChangeNotifierProvider(
      create: (_) => participantContext,
      child: builder(context),
    );
  }
}
