import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import 'connection_quality_indicator.dart';
import 'e2e_encryption_indicator.dart';

class ParticipantWidget extends StatelessWidget {
  const ParticipantWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) =>
          Selector<ParticipantContext, List<VideoTrack>>(
        selector: (context, tracks) => participantContext.videoTracks,
        builder: (context, tracks, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tracks.isNotEmpty
                ? Expanded(
                    child: VideoTrackRenderer(tracks.first),
                  )
                : const Icon(
                    Icons.videocam_off,
                    color: Colors.grey,
                  ),
            Text(participantContext.identity),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConnectionQualityIndicator(),
                E2EEncryptionIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
