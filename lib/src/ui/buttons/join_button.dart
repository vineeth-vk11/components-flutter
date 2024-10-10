import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livekit_components/livekit_components.dart';

class JoinButton extends StatelessWidget {
  JoinButton({super.key, this.onPressed});

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, connected) => roomCtx.connected,
        builder: (context, connected, child) => ElevatedButton(
          onPressed: () => onPressed != null
              ? onPressed!()
              : !connected
                  ? roomCtx.connect()
                  : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
                connected ? Colors.grey : LKColors.lkBlue),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            //overlayColor: WidgetStateProperty.all(
            //    connected ? Colors.grey : LKColors.lkLightBlue),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
            padding: WidgetStateProperty.all(
                const EdgeInsets.fromLTRB(10, 20, 10, 20)),
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
