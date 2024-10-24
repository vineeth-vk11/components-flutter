import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/track_reference_context.dart';
import '../../debug/logger.dart';

class ParticipantName extends StatelessWidget {
  const ParticipantName({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, String? name) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log('====>        ParticipantName for ${participantContext.name}');
      var trackCtx = Provider.of<TrackReferenceContext?>(context);
      bool isScreenShare = trackCtx?.isScreenShare ?? false;
      return Selector<ParticipantContext, String?>(
        selector: (context, name) => participantContext.name,
        builder: (context, name, child) {
          var str = isScreenShare ? '$name\'s screen' : name;
          return builder(context, str);
        },
      );
    });
  }
}
