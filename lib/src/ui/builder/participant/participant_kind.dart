import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../../context/participant_context.dart';
import '../../../debug/logger.dart';

class ParticipantKind extends StatelessWidget {
  const ParticipantKind({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, lk.ParticipantKind kind) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log('====>        ParticipantKind for ${participantContext.kind}');
      return Selector<ParticipantContext, lk.ParticipantKind>(
        selector: (context, name) => participantContext.kind,
        builder: (context, kind, child) {
          return builder(context, kind);
        },
      );
    });
  }
}
