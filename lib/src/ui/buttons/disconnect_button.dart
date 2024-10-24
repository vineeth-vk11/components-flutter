import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../context/room_context.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton(
      {super.key, this.title = 'Leave', this.showLabel = false});

  final String title;

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, connected) => roomCtx.connected,
        builder: (context, connected, child) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  connected ? Colors.red : Colors.grey.withOpacity(0.6)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(
                  connected ? Colors.redAccent : Colors.grey),
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
            onPressed: () => connected ? roomCtx.disconnect() : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: 2),
                if (deviceScreenType != DeviceScreenType.mobile || showLabel)
                  Text(
                    title,
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
