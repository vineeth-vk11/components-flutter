import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../context/room.dart';
import '../../types/theme.dart';

class ChatToggle extends StatelessWidget {
  const ChatToggle({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
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
                deviceScreenType == DeviceScreenType.desktop ||
                        lkPlatformIsDesktop()
                    ? const EdgeInsets.fromLTRB(10, 20, 10, 20)
                    : const EdgeInsets.all(12),
              ),
            ),
            onPressed: () =>
                isChatEnabled ? roomCtx.disableChat() : roomCtx.enableChat(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chat_outlined),
                const SizedBox(width: 2),
                if (deviceScreenType != DeviceScreenType.mobile)
                  const Text(
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
