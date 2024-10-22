import 'package:flutter/material.dart';
import 'package:livekit_components/src/ui/debug/logger.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class FocusButton extends StatelessWidget {
  const FocusButton({
    super.key,
    required this.sid,
  });

  final String? sid;
  @override
  Widget build(BuildContext context) {
    final roomCtx = context.read<RoomContext>();
    Debug.log('===>     FocusButton for $sid');
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
