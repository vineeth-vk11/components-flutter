import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../context/room.dart';
import '../../context/track.dart';
import '../layout/layouts.dart';
import '../debug/logger.dart';

class ParticipantLoop extends StatelessWidget {
  ParticipantLoop({
    super.key,
    required this.builder,
    this.layoutBuilder = const GridLayoutBuilder(),
    this.showAudio = false,
    this.showVideo = true,
  });

  final WidgetBuilder builder;
  final ParticipantLayoutBuilder layoutBuilder;

  final List<ParticipantLayoutBuilder> layoutBuilders = [
    const GridLayoutBuilder(),
    const CarouselLayoutBuilder(),
  ];

  final bool showAudio;
  final bool showVideo;

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
                  if (track.kind == TrackType.AUDIO && !showAudio) {
                    continue;
                  }
                  if (track.kind == TrackType.VIDEO && !showVideo) {
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
                        create: (_) => TrackContext(participant, pub: track),
                      ),
                    ],
                    child: builder(context),
                  );

                  Debug.log(
                      '=>  ${track.source.toString()} track ${track.sid} for ${participant.identity}');
                }

                if (!showAudio &&
                        !tracks.any((t) => t.kind == TrackType.VIDEO) ||
                    !showVideo &&
                        tracks.any((t) => t.kind == TrackType.AUDIO) ||
                    tracks.isEmpty) {
                  trackWidgets[participant.identity] = ChangeNotifierProvider(
                    key: ValueKey(participant.identity),
                    create: (_) => ParticipantContext(participant),
                    child: builder(context),
                  );

                  Debug.log('=>  no tracks for ${participant.identity}');
                }
              }
              var children = trackWidgets.values.toList();

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
