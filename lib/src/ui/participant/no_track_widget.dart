import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/track_context.dart';
import '../../types/theme.dart';
import '../debug/logger.dart';

class NoTrackWidget extends StatelessWidget {
  const NoTrackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    final String? sid = trackCtx?.sid;
    Debug.log('===>     NoTrackWidget for $sid');

    var icon = Icons.videocam_off_outlined;
    if (trackCtx?.isAudio == true) {
      if (trackCtx?.isLocal == true) {
        if (trackCtx?.isMuted == true) {
          icon = Icons.mic_off_outlined;
        } else {
          icon = Icons.mic_none_outlined;
        }
      } else {
        if (trackCtx?.isMuted == true) {
          icon = Icons.volume_off_outlined;
        } else {
          icon = Icons.volume_up_outlined;
        }
      }
    }

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Icon(
          icon,
          color: LKColors.lkBlue,
          size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
        ),
      ),
    );
  }
}
