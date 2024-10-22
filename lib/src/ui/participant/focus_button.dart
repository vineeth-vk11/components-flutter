import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class FocusButton extends StatelessWidget {
  const FocusButton({
    super.key,
    required this.sid,
  });

  final String sid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: IconButton(
        icon: const Icon(Icons.fullscreen),
        color: Colors.white54,
        onPressed: () {
          final roomCtx = context.read<RoomContext>();
          roomCtx.setFocusedTrack(sid);
        },
      ),
    );
  }
}
