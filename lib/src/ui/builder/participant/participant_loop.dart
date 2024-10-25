import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../context/room_context.dart';
import '../../../debug/logger.dart';
import '../../layout/grid_layout.dart';
import '../../layout/layouts.dart';
import 'participant_track.dart';

class ParticipantLoop extends StatelessWidget {
  const ParticipantLoop({
    super.key,
    required this.participantBuilder,
    this.layoutBuilder = const GridLayoutBuilder(),
    this.sorting,
    this.showAudioTracks = false,
    this.showVideoTracks = true,
  });

  final WidgetBuilder participantBuilder;
  final Map<Participant, TrackPublication?> Function(
      Map<Participant, TrackPublication?> tracks)? sorting;
  final ParticipantLayoutBuilder layoutBuilder;

  final bool showAudioTracks;
  final bool showVideoTracks;

  Map<Participant, TrackPublication?> buildTracksMap(
      bool audio, bool video, List<Participant> participants) {
    final Map<Participant, TrackPublication?> trackMap = {};
    int index = 0;
    for (Participant participant in participants) {
      Debug.log('=>  participant ${participant.identity}, index: $index');
      index++;
      var tracks = participant.trackPublications.values;
      for (var track in tracks) {
        if (track.kind == TrackType.AUDIO && !audio) {
          continue;
        }
        if (track.kind == TrackType.VIDEO && !video) {
          continue;
        }
        trackMap[participant] = track;

        Debug.log(
            '=>  ${track.source.toString()} track ${track.sid} for ${participant.identity}');
      }

      if (!audio && !tracks.any((t) => t.kind == TrackType.VIDEO) ||
          !video && tracks.any((t) => t.kind == TrackType.AUDIO) ||
          tracks.isEmpty) {
        trackMap[participant] = null;

        Debug.log('=>  no tracks for ${participant.identity}');
      }
    }

    return trackMap;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        Debug.log('>  ParticipantLoop for ${roomCtx.roomName}');
        return Selector<RoomContext, List<Participant>>(
            selector: (context, participants) => roomCtx.participants,
            shouldRebuild: (previous, next) => previous.length != next.length,
            builder: (context, participants, child) {
              var roomCtx = Provider.of<RoomContext>(context);

              Map<String, Widget> trackWidgets = {};

              var trackMap = buildTracksMap(
                  showAudioTracks, showVideoTracks, participants);

              if (sorting != null) {
                trackMap = sorting!(trackMap);
              }

              for (var item in trackMap.entries) {
                var participant = item.key;
                var track = item.value;
                if (track == null) {
                  trackWidgets[participant.identity] = ParticipantTrack(
                    participant: participant,
                    builder: (context) => participantBuilder(context),
                  );
                } else {
                  trackWidgets[track.sid] = ParticipantTrack(
                    participant: participant,
                    track: track,
                    builder: (context) => participantBuilder(context),
                  );
                }
              }

              var children = trackWidgets.values.toList();
              List<Widget> pinned = [];

              /// Move focused tracks to the pinned list
              var focused = roomCtx.pinnedTracks
                  .map((e) {
                    if (trackWidgets.containsKey(e)) {
                      return trackWidgets[e]!;
                    }
                    return null;
                  })
                  .whereType<Widget>()
                  .toList();

              if (focused.isNotEmpty) {
                children.removeWhere((e) => focused.contains(e));
                pinned.addAll(focused);
              }

              return layoutBuilder.build(context, children, pinned);
            });
      },
    );
  }
}
