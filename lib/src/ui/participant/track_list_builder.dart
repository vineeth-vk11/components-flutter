import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../livekit_components.dart';

typedef TrackListWidgetBuilder = Widget Function(
    BuildContext context, List<TrackPublication>);

class TrackListBuilder extends StatelessWidget {
  const TrackListBuilder({
    super.key,
    required this.builder,
    this.isVideo = true,
    this.isAudio = false,
  });
  final TrackListWidgetBuilder builder;

  final bool isVideo;
  final bool isAudio;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) {
        return Selector<ParticipantContext, List<TrackPublication>>(
          selector: (context, tracks) => participantContext.tracks.where(
            (track) {
              if (isVideo &&
                  track.kind == TrackType.VIDEO &&
                  track.muted == false &&
                  track.track != null) {
                return true;
              }
              if (isAudio &&
                  track.kind == TrackType.AUDIO &&
                  track.track != null) {
                return true;
              }
              return false;
            },
          ).toList(),
          builder: (context, tracks, child) => builder(context, tracks),
        );
      },
    );
  }
}
