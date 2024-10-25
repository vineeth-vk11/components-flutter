import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/track_reference_context.dart';
import '../../../debug/logger.dart';
import '../../builder/track/is_speaking_indicator.dart';
import '../track/focus_toggle.dart';
import 'is_speaking_indicator.dart';
import 'participant_status_bar.dart';
import '../track/track_stats_widget.dart';
import '../track/video_track_widget.dart';

class ParticipantTileWidget extends StatelessWidget {
  const ParticipantTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackReferenceContext?>(context);
    Debug.log(
        '>  ParticipantTile for track ${trackCtx?.sid}@${trackCtx?.participant.identity}');

    return Stack(
      children: [
        /// video track widget in the background
        IsSpeakingIndicator(builder: (context, isSpeaking) {
          return isSpeaking != null
              ? IsSpeakingIndicatorWidget(
                  isSpeaking: isSpeaking,
                  child: const VideoTrackWidget(),
                )
              : const VideoTrackWidget();
        }),

        /// focus toggle button at the top right
        const Positioned(
          top: 0,
          right: 0,
          child: FocusToggle(),
        ),

        /// track stats at the bottom right
        const Positioned(
          bottom: 30,
          right: 0,
          child: TrackStatsWidget(),
        ),

        /// status bar at the bottom
        const ParticipantStatusBar(),
      ],
    );
  }
}
