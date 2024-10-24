import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../debug/logger.dart';

class ParticipantMetadata extends StatelessWidget {
  const ParticipantMetadata({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, String? metadata) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantMetadata for ${participantContext.metadata}');
      return Selector<ParticipantContext, String?>(
        selector: (context, metadata) => participantContext.metadata,
        builder: (context, metadata, child) {
          return builder(context, metadata);
        },
      );
    });
  }
}
