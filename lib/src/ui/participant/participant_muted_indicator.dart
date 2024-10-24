import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../debug/logger.dart';

class ParticipantMutedIndicator extends StatelessWidget {
  const ParticipantMutedIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantMutedIndicator for ${participantContext.name}');
      return Selector<ParticipantContext, bool>(
        selector: (context, isMuted) => participantContext.isMuted,
        builder: (context, isMuted, child) => isMuted
            ? const Icon(
                Icons.mic_off_sharp,
                color: Colors.white54,
                size: 20,
              )
            : const SizedBox(),
      );
    });
  }
}
