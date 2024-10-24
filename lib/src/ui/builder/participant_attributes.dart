import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../debug/logger.dart';

class ParticipantAttributes extends StatelessWidget {
  const ParticipantAttributes({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, Map<String, String>? attributes)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantAttributes for ${participantContext.attributes}');
      return Selector<ParticipantContext, Map<String, String>?>(
        selector: (context, attributes) => participantContext.attributes,
        builder: (context, attributes, child) {
          return builder(context, attributes);
        },
      );
    });
  }
}
