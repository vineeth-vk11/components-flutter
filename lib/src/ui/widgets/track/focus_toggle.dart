import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/room_context.dart';
import '../../../context/track_reference_context.dart';
import '../../../debug/logger.dart';

class FocusToggle extends StatelessWidget {
  const FocusToggle({
    super.key,
    this.showBackToGridView = false,
  });

  final bool showBackToGridView;

  @override
  Widget build(BuildContext context) {
    final roomCtx = context.read<RoomContext>();
    var trackCtx = Provider.of<TrackReferenceContext?>(context);
    final String? sid = trackCtx?.sid;
    Debug.log('===>     FocusButton for $sid');
    if (trackCtx == null) {
      return const SizedBox();
    }
    var shouldShowBackToGridView =
        roomCtx.pinnedTracks.contains(sid) && sid == roomCtx.pinnedTracks.first;

    if (shouldShowBackToGridView && !showBackToGridView) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: IconButton(
        icon: Icon(
            shouldShowBackToGridView ? Icons.grid_view : Icons.open_in_full),
        color: Colors.white70,
        onPressed: () {
          if (sid == null) {
            return;
          }
          if (shouldShowBackToGridView) {
            roomCtx.clearPinnedTracks();
          } else {
            roomCtx.pinningTrack(sid);
          }
        },
      ),
    );
  }
}
