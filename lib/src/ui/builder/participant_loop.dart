import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant_context.dart';
import '../../context/room_context.dart';
import '../../context/track_reference_context.dart';
import '../../debug/logger.dart';
import '../layout/grid_layout.dart';
import '../layout/layouts.dart';

class ParticipantLoop extends StatelessWidget {
  const ParticipantLoop({
    super.key,
    required this.participantBuilder,
    this.layoutBuilder = const GridLayoutBuilder(),
    this.showAudioTracks = false,
    this.showVideoTracks = true,
  });

  final WidgetBuilder participantBuilder;
  final ParticipantLayoutBuilder layoutBuilder;

  final bool showAudioTracks;
  final bool showVideoTracks;

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
              final Map<String, Widget> trackWidgets = {};
              int index = 0;
              for (Participant participant in participants) {
                Debug.log(
                    '=>  participant ${participant.identity}, index: $index');
                index++;
                var tracks = participant.trackPublications.values;
                for (var track in tracks) {
                  if (track.kind == TrackType.AUDIO && !showAudioTracks) {
                    continue;
                  }
                  if (track.kind == TrackType.VIDEO && !showVideoTracks) {
                    continue;
                  }
                  trackWidgets[track.sid] = MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        key: ValueKey(track.sid),
                        create: (_) => ParticipantContext(participant),
                      ),
                      ChangeNotifierProvider(
                        key: ValueKey(track.sid),
                        create: (_) =>
                            TrackReferenceContext(participant, pub: track),
                      ),
                    ],
                    child: participantBuilder(context),
                  );

                  Debug.log(
                      '=>  ${track.source.toString()} track ${track.sid} for ${participant.identity}');
                }

                if (!showAudioTracks &&
                        !tracks.any((t) => t.kind == TrackType.VIDEO) ||
                    !showVideoTracks &&
                        tracks.any((t) => t.kind == TrackType.AUDIO) ||
                    tracks.isEmpty) {
                  trackWidgets[participant.identity] = ChangeNotifierProvider(
                    key: ValueKey(participant.identity),
                    create: (_) => ParticipantContext(participant),
                    child: participantBuilder(context),
                  );

                  Debug.log('=>  no tracks for ${participant.identity}');
                }
              }
              var children = trackWidgets.values.toList();

              /// Move focused track to the front
              var focused = trackWidgets.entries
                  .where((e) => e.key == roomCtx.focusedTrackSid)
                  .firstOrNull;

              if (focused != null) {
                children.remove(focused.value);
                children.insert(0, focused.value);
              }
              return layoutBuilder.build(context, children);
            });
      },
    );
  }
}
