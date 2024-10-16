import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../context/room.dart';
import '../layout/layouts.dart';
import '../debug/logger.dart';
import '../../context/track.dart';

typedef ParticipantBuilder = Widget Function(
    BuildContext context, TrackContext);

class ParticipantListBuilder extends StatelessWidget {
  ParticipantListBuilder({
    super.key,
    required this.builder,
    this.layoutBuilder = const GridLayoutBuilder(),
  });
  final ParticipantBuilder builder;
  final ParticipantLayoutBuilder layoutBuilder;
  final Map<TrackContext, Widget> children = {};
  @override
  Widget build(BuildContext context) {
    Debug.log('ParticipantListBuilder build');
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Selector<RoomContext, List<Participant>>(
            selector: (context, participants) => roomCtx.participants,
            builder: (context, participants, child) {
              Debug.log('participants ${participants.length}');
              for (var paticipant in participants) {
                var ctx = TrackContext(paticipant, isScreenShare: false);
                children[ctx] = MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (_) => ParticipantContext(paticipant)),
                    ChangeNotifierProvider(create: (_) => ctx),
                  ],
                  child: builder(context, ctx),
                );
                for (var track in ctx.tracks) {
                  if (track.source == TrackSource.screenShareVideo) {
                    var ctx = TrackContext(paticipant, isScreenShare: true);
                    children[ctx] = MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => ParticipantContext(paticipant)),
                        ChangeNotifierProvider(create: (_) => ctx),
                      ],
                      child: builder(context, ctx),
                    );
                  }
                }
              }

              return layoutBuilder.build(context, children);
            });
      },
    );
  }
}
