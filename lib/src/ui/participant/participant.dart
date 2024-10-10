import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../types/theme.dart';
import '../debug/logger.dart';
import 'is_speaking_indicator.dart';
import 'participant_tile.dart';
import 'track_list_builder.dart';

class ParticipantWidget extends StatelessWidget {
  const ParticipantWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) {
        Debug.log(
            'ParticipantWidget build ${participantContext.participant.identity}');
        return IsSpeakingIndicator(
          builder: (context) => Stack(
            children: [
              /*
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ),
              ),
            ),*/
              TrackListBuilder(
                builder: (context, tracks) {
                  return tracks.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (final track in tracks)
                              if (track.track != null)
                                Expanded(
                                  child: VideoTrackRenderer(
                                      track.track as VideoTrack),
                                )
                          ],
                        )
                      : Expanded(
                          child: Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) => Icon(
                                Icons.videocam_off_outlined,
                                color: LKColors.lkBlue,
                                size: math.min(constraints.maxHeight,
                                        constraints.maxWidth) *
                                    0.3,
                              ),
                            ),
                          ),
                        );
                },
              ),
              const ParticipantTile(),
            ],
          ),
        );
      },
    );
  }
}
