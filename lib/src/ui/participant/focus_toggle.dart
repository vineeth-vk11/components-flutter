import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livekit_components/src/ui/debug/logger.dart';
import '../../context/room.dart';
import '../../context/track.dart';

class FocusToggle extends StatelessWidget {
  const FocusToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roomCtx = context.read<RoomContext>();
    var trackCtx = Provider.of<TrackContext?>(context);
    final String? sid = trackCtx?.sid;
    Debug.log('===>     FocusButton for $sid');
    if (trackCtx == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: IconButton(
        icon: Icon(sid == roomCtx.focusedTrackSid
            ? Icons.grid_view
            : Icons.open_in_full),
        color: Colors.white70,
        onPressed: () {
          if (sid == null) {
            return;
          }
          if (sid == roomCtx.focusedTrackSid) {
            roomCtx.setFocusedTrack(null);
            return;
          }
          roomCtx.setFocusedTrack(sid);
        },
      ),
    );
  }
}
