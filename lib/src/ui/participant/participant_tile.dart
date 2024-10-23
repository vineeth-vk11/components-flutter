import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/track.dart';
import '../debug/logger.dart';
import '../debug/track_stats.dart';
import 'focus_toggle.dart';
import 'is_speaking_indicator.dart';
import 'participant_status_bar.dart';
import 'video_track_widgets.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
    this.showSpeakingIndicator = true,
  });

  final bool showSpeakingIndicator;

  Widget buildContent(BuildContext context, TrackContext? trackCtx) {
    return Stack(
      children: [
        /// video track
        const VideoTrackWidget(),
        if (trackCtx != null)
          const Positioned(
            top: 0,
            right: 0,
            child: FocusToggle(),
          ),
        if (trackCtx != null)
          const Positioned(
            bottom: 30,
            right: 0,
            child: TrackStatsWidget(),
          ),
        const ParticipantStatusBar(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    Debug.log(
        '>  ParticipantTile for track ${trackCtx?.sid}@${trackCtx?.participant.identity}');

    if (showSpeakingIndicator) {
      return IsSpeakingIndicator(
        builder: (context) => buildContent(context, trackCtx),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: buildContent(context, trackCtx),
    );
  }
}
