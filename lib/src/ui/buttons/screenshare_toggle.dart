import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livekit_components/livekit_components.dart';

class ScreenShareToggle extends StatelessWidget {
  const ScreenShareToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, screenShareEnabled) => roomCtx.isScreenShareEnabled,
        builder: (context, screenShareEnabled, child) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(screenShareEnabled
                  ? LKColors.lkBlue
                  : Colors.grey.withOpacity(0.6)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(
                  screenShareEnabled ? LKColors.lkLightBlue : Colors.grey),
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
            onPressed: () => screenShareEnabled
                ? roomCtx.disableScreenShare()
                : roomCtx.enableScreenShare(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(screenShareEnabled
                    ? Icons.stop_screen_share_outlined
                    : Icons.screen_share_outlined),
                const SizedBox(width: 2),
                Text(
                  screenShareEnabled ? 'Stop screen share ' : 'Screen share',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
