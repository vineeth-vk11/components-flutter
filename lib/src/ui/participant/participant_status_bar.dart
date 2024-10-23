import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../context/track.dart';
import '../debug/logger.dart';
import 'connection_quality_indicator.dart';
import 'e2e_encryption_indicator.dart';
import 'participant_muted_indicator.dart';
import 'participant_name.dart';

class ParticipantStatusBar extends StatelessWidget {
  const ParticipantStatusBar({
    super.key,
    this.showName = true,
    this.showE2EEStatus = true,
    this.showConnectionQuality = true,
    this.showMuteStatus = true,
  });

  final bool showName;
  final bool showE2EEStatus;
  final bool showConnectionQuality;
  final bool showMuteStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) {
        Debug.log(
            '===>     ParticipantStatusBar for ${participantContext.name}');
        var trackCtx = Provider.of<TrackContext?>(context);
        var isScreenShare = trackCtx?.isScreenShare ?? false;
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.black.withOpacity(0.6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showMuteStatus && !isScreenShare)
                    const ParticipantMutedIndicator(),
                  if (isScreenShare)
                    const Icon(
                      Icons.screen_share,
                      color: Colors.white54,
                      size: 20,
                    ),
                  if (showName) const ParticipantName(),
                  if (showConnectionQuality) const ConnectionQualityIndicator(),
                  if (showE2EEStatus) const E2EEncryptionIndicator(),
                ]),
          ),
        );
      },
    );
  }
}
