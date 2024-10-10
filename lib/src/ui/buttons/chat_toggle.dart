import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livekit_components/livekit_components.dart';

class ChatToggle extends StatelessWidget {
  const ChatToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, isChatEnabled) => roomCtx.isChatEnabled,
        builder: (context, isChatEnabled, child) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(isChatEnabled
                  ? LKColors.lkBlue
                  : Colors.grey.withOpacity(0.6)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(
                  isChatEnabled ? LKColors.lkLightBlue : Colors.grey),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.fromLTRB(12, 20, 10, 20)),
            ),
            onPressed: () =>
                isChatEnabled ? roomCtx.disableChat() : roomCtx.enableChat(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_outlined),
                SizedBox(width: 2),
                Text(
                  'Chat',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
