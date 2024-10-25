import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/room_context.dart';

class ClearPinButton extends StatelessWidget {
  const ClearPinButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roomCtx = context.read<RoomContext>();
    return Padding(
      padding: const EdgeInsets.all(2),
      child: IconButton(
        icon: Icon(Icons.grid_view),
        color: Colors.white70,
        onPressed: () {
          roomCtx.clearPinnedTracks();
        },
      ),
    );
  }
}
