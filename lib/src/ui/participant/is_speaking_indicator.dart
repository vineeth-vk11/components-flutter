import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../context/track.dart';
import '../../types/theme.dart';
import '../debug/logger.dart';

class IsSpeakingIndicator extends StatelessWidget {
  const IsSpeakingIndicator({
    super.key,
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    var participantContext = Provider.of<ParticipantContext>(context);
    var trackCtx = Provider.of<TrackContext?>(context);

    /// Show speaking indicator only if the participant is not sharing screen
    var showSpeakingIndicator = !(trackCtx?.isScreenShare ?? true);
    Debug.log('===>     IsSpeakingIndicator for ${participantContext.name}');
    return Selector<ParticipantContext, bool>(
      selector: (context, isSpeaking) => participantContext.isSpeaking,
      builder: (context, isSpeaking, child) => Container(
        foregroundDecoration: BoxDecoration(
          border: participantContext.isSpeaking && showSpeakingIndicator
              ? Border.all(
                  width: 3,
                  color: LKColors.lkBlue,
                )
              : null,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: builder(context),
      ),
    );
  }
}
