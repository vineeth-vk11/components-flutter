import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:provider/provider.dart';

import '../../../context/participant_context.dart';
import '../../../context/track_reference_context.dart';

class ParticipantTrack extends StatelessWidget {
  const ParticipantTrack({
    super.key,
    required this.participant,
    this.track,
    required this.builder,
  });

  final lk.Participant participant;
  final lk.TrackPublication? track;

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    if (track == null) {
      return ChangeNotifierProvider(
        key: ValueKey(participant.identity),
        create: (_) => ParticipantContext(participant),
        child: builder(context),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          key: ValueKey(track!.sid),
          create: (_) => ParticipantContext(participant),
        ),
        ChangeNotifierProvider(
          key: ValueKey(track!.sid),
          create: (_) => TrackReferenceContext(participant, pub: track),
        ),
      ],
      child: builder(context),
    );
  }
}
