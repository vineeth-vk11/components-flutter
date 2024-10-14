import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';
import '../../types/theme.dart';
import '../debug/logger.dart';
import 'is_speaking_indicator.dart';
import 'participant_status_bar.dart';
import '../../context/track.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) {
        var ctx = Provider.of<TrackContext>(context);
        var videoTrack = ctx.isScreenShare ? ctx.screenTrack : ctx.videoTrack;
        Debug.log(
            'ParticipantWidget build ${participantContext.participant.identity}');
        return IsSpeakingIndicator(
          builder: (context) => Stack(
            children: [
              videoTrack != null
                  ? Expanded(
                      child: VideoTrackRenderer(videoTrack),
                    )
                  : Expanded(
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) => Icon(
                            Icons.videocam_off_outlined,
                            color: LKColors.lkBlue,
                            size: math.min(constraints.maxHeight,
                                    constraints.maxWidth) *
                                0.3,
                          ),
                        ),
                      ),
                    ),
              ParticipantStatusBar(
                showMuteStatus: !ctx.isScreenShare,
                isScreenShare: ctx.isScreenShare,
                showE2EEStatus: !ctx.isScreenShare,
              ),
            ],
          ),
        );
      },
    );
  }
}
