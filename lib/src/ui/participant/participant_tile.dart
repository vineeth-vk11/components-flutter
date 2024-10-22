import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../../context/track.dart';

import '../debug/logger.dart';
import 'focus_button.dart';
import 'is_speaking_indicator.dart';
import 'no_video_widgets.dart';
import 'participant_status_bar.dart';

typedef SpeakingIndicatorBuilder = Widget Function(
    BuildContext context, Widget child);

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
    this.showSpeakingIndicator = true,
  });

  final bool showSpeakingIndicator;

  Widget buildContent(BuildContext context, TrackContext? trackCtx) {
    var trackCtx = Provider.of<TrackContext?>(context);
    var isScreenShare = trackCtx?.isScreenShare ?? false;
    var trackSid = trackCtx?.sid ?? '';
    return Stack(
      children: [
        if (trackCtx != null)
          Selector<TrackContext, bool>(
            selector: (context, isMuted) => trackCtx.isMuted,
            builder: (BuildContext context, isMuted, child) =>
                !isMuted && trackCtx.videoTrack != null
                    ? VideoTrackRenderer(trackCtx.videoTrack!)
                    : NoVideoWidget(sid: trackSid),
          ),
        if (trackCtx == null) NoVideoWidget(sid: trackSid),
        if (trackCtx != null)
          Positioned(
            top: 0,
            right: 0,
            child: FocusButton(sid: trackSid),
          ),
        ParticipantStatusBar(
          showMuteStatus: !isScreenShare,
          isScreenShare: isScreenShare,
          showE2EEStatus: !isScreenShare,
        ),
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
    return buildContent(context, trackCtx);
  }
}
