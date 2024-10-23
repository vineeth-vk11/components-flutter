import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/track.dart';
import '../debug/logger.dart';
import '../debug/track_stats_widget.dart';
import 'focus_toggle.dart';
import 'is_speaking_indicator.dart';
import 'participant_status_bar.dart';
import 'video_track_widget.dart';

class ParticipantTileWidget extends StatelessWidget {
  const ParticipantTileWidget({
    super.key,
    this.showSpeakingIndicator = true,
  });

  final bool showSpeakingIndicator;

  Widget buildContent() => const Stack(
        children: [
          /// video track widget in the background
          VideoTrackWidget(),

          /// focus toggle button at the top right
          Positioned(
            top: 0,
            right: 0,
            child: FocusToggle(),
          ),

          /// track stats at the bottom right
          Positioned(
            bottom: 30,
            right: 0,
            child: TrackStatsWidget(),
          ),

          /// status bar at the bottom
          ParticipantStatusBar(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    Debug.log(
        '>  ParticipantTile for track ${trackCtx?.sid}@${trackCtx?.participant.identity}');

    if (showSpeakingIndicator) {
      return IsSpeakingIndicator(
        builder: (context) => buildContent(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: buildContent(),
    );
  }
}
