import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../debug/logger.dart';

class ParticipantMutedIndicator extends StatelessWidget {
  const ParticipantMutedIndicator({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isMuted) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantMutedIndicator for ${participantContext.name}');
      return Selector<ParticipantContext, bool>(
        selector: (context, isMuted) => participantContext.isMuted,
        builder: (context, isMuted, child) => builder(context, isMuted),
      );
    });
  }
}
