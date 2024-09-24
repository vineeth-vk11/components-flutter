import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../livekit_components.dart';

typedef TrackWidgetBuilder = Widget Function(
    BuildContext context, Track? track);

class TrackListBuilder extends StatelessWidget {
  const TrackListBuilder({super.key, required this.builder});
  final TrackWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
        builder: (context, participantContext, child) {
      return Selector<ParticipantContext, List<TrackPublication>>(
        selector: (context, tracks) => participantContext.tracks,
        builder: (context, tracks, child) => GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.0),
          children: tracks
              .map(
                (t) => builder(context, t.track),
              )
              .toList(),
        ),
      );
    });
  }
}
