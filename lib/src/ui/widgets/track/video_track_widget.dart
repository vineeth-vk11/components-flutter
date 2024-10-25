import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../context/track_reference_context.dart';
import '../../../debug/logger.dart';
import 'no_track_widget.dart';
import '../theme.dart';

class VideoTrackWidget extends StatelessWidget {
  const VideoTrackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackReferenceContext?>(context);
    final String? sid = trackCtx?.sid;

    Debug.log('===>     VideoTrackWidget for $sid');

    if (trackCtx == null) {
      return const NoTrackWidget();
    }

    return Selector<TrackReferenceContext, bool>(
      selector: (context, isMuted) => trackCtx.isMuted,
      builder: (BuildContext context, isMuted, child) => !isMuted &&
              trackCtx.videoTrack != null
          ? Container(
              color: LKColors.lkDarkBlue,
              child:
                  VideoTrackRenderer(trackCtx.videoTrack!, key: ValueKey(sid)))
          : const NoTrackWidget(),
    );
  }
}
