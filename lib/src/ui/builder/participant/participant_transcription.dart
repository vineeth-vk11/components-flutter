import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../context/participant_context.dart';
import '../../../debug/logger.dart';

class ParticipantTranscription extends StatelessWidget {
  const ParticipantTranscription({
    super.key,
    required this.builder,
  });

  final Widget Function(
      BuildContext context, List<TranscriptionSegment> segments) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantTranscription for ${participantContext.segments}');
      return Selector<ParticipantContext, List<TranscriptionSegment>>(
        selector: (context, segments) => participantContext.segments,
        builder: (context, segments, child) {
          return builder(context, segments);
        },
      );
    });
  }
}
