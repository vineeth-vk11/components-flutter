import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../types/theme.dart';

class IsSpeakingIndicator extends StatelessWidget {
  const IsSpeakingIndicator({
    super.key,
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) =>
          Selector<ParticipantContext, bool>(
        selector: (context, isSpeaking) => participantContext.isSpeaking,
        builder: (context, isSpeaking, child) => Container(
          foregroundDecoration: BoxDecoration(
            border: participantContext.isSpeaking
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
      ),
    );
  }
}
