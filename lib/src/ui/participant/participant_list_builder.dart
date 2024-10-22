import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../context/room.dart';
import '../layout/layouts.dart';
import '../debug/logger.dart';
import '../../context/track.dart';

class ParticipantListBuilder extends StatelessWidget {
  const ParticipantListBuilder({
    super.key,
    required this.builder,
    this.layoutBuilder = const GridLayoutBuilder(),
    this.showAudio = false,
    this.showVideo = true,
  });

  final WidgetBuilder builder;
  final ParticipantLayoutBuilder layoutBuilder;

  final bool showAudio;
  final bool showVideo;

  @override
  Widget build(BuildContext context) {
    Debug.log('ParticipantListBuilder build');
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Selector<RoomContext, List<Participant>>(
            selector: (context, participants) => roomCtx.participants,
            builder: (context, participants, child) {
              final List<Widget> children = [];
              Debug.log('participants ${participants.length}');
              for (var paticipant in participants) {
                var tracks = paticipant.trackPublications.values;
                for (var track in tracks) {
                  if (track.kind == TrackType.AUDIO && !showAudio) {
                    continue;
                  }
                  if (track.kind == TrackType.VIDEO && !showVideo) {
                    continue;
                  }
                  children.add(
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => ParticipantContext(paticipant)),
                        ChangeNotifierProvider(
                          create: (_) => TrackContext(paticipant, pub: track),
                        ),
                      ],
                      child: builder(context),
                    ),
                  );
                }

                if (tracks.isEmpty) {
                  children.add(
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => ParticipantContext(paticipant)),
                        ChangeNotifierProvider(
                            create: (_) => TrackContext(paticipant, pub: null)),
                      ],
                      child: builder(context),
                    ),
                  );
                }
              }

              return layoutBuilder.build(context, children);
            });
      },
    );
  }
}
