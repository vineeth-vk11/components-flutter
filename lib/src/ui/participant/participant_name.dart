import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/track_context.dart';
import '../debug/logger.dart';

class ParticipantName extends StatelessWidget {
  const ParticipantName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      Debug.log('====>        ParticipantName for ${participantContext.name}');
      var trackCtx = Provider.of<TrackContext?>(context);
      bool isScreenShare = trackCtx?.isScreenShare ?? false;
      return Selector<ParticipantContext, String?>(
        selector: (context, name) => participantContext.name,
        builder: (context, name, child) => name != null
            ? Flexible(
                child: Text(
                  isScreenShare ? '$name\'s screen' : name,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Container(),
      );
    });
  }
}
