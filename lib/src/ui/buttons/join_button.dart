import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';

import 'package:provider/provider.dart';

class JoinButton extends StatelessWidget {
  const JoinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, connected) => roomCtx.connected,
        builder: (context, connected, child) => TextButton(
          onPressed: () => !connected ? roomCtx.connect() : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
                connected ? Colors.grey : LKColors.lkBlue),
          ),
          child: const Text(
            'Join Room',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    });
  }
}
