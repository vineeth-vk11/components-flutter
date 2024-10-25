import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:provider/provider.dart';

import '../../../context/participant_context.dart';
import '../../../debug/logger.dart';

class ParticipantPermissions extends StatelessWidget {
  const ParticipantPermissions({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, lk.ParticipantPermissions?)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log(
          '====>        ParticipantPermissions for ${participantContext.permissions}');
      return Selector<ParticipantContext, lk.ParticipantPermissions?>(
        selector: (context, permissions) => participantContext.permissions,
        builder: (context, permissions, child) {
          return builder(context, permissions);
        },
      );
    });
  }
}
