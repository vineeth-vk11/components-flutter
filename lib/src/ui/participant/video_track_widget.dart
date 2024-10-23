import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/track.dart';
import '../debug/logger.dart';
import 'no_video_widget.dart';

class VideoTrackWidget extends StatelessWidget {
  const VideoTrackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    final String? sid = trackCtx?.sid;

    Debug.log('===>     VideoTrackWidget for $sid');

    if (trackCtx == null) {
      return const NoVideoWidget();
    }

    return Selector<TrackContext, bool>(
      selector: (context, isMuted) => trackCtx.isMuted,
      builder: (BuildContext context, isMuted, child) =>
          !isMuted && trackCtx.videoTrack != null
              ? VideoTrackRenderer(trackCtx.videoTrack!, key: ValueKey(sid))
              : const NoVideoWidget(),
    );
  }
}
