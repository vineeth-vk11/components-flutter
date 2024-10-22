import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../../context/track.dart';

import 'focus_button.dart';
import 'is_speaking_indicator.dart';
import 'no_video_widgets.dart';
import 'participant_status_bar.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = context.read<TrackContext>();
    var roomCtx = context.read<RoomContext>();
    return IsSpeakingIndicator(
      builder: (context) => Stack(
        children: [
          Consumer<TrackContext>(
            builder: (context, trackCtx, child) {
              return !trackCtx.isMuted
                  ? Expanded(
                      child: VideoTrackRenderer(trackCtx.videoTrack!),
                    )
                  : const NoVideoWidget();
            },
          ),
          if (trackCtx.sid != roomCtx.focusedTrackSid)
            Positioned(
              top: 0,
              right: 0,
              child: FocusButton(sid: trackCtx.sid),
            ),
          ParticipantStatusBar(
            showMuteStatus: !trackCtx.isScreenShare,
            isScreenShare: trackCtx.isScreenShare,
            showE2EEStatus: !trackCtx.isScreenShare,
          ),
        ],
      ),
    );
  }
}
