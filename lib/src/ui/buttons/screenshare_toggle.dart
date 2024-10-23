import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../context/media_device.dart';
import '../../context/room.dart';
import '../../types/theme.dart';

class ScreenShareToggle extends StatelessWidget {
  const ScreenShareToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return ChangeNotifierProvider(
          create: (_) => MediaDeviceContext(roomCtx: roomCtx),
          child: Consumer<MediaDeviceContext>(
            builder: (context, deviceCtx, child) {
              var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
              return Selector<MediaDeviceContext, bool>(
                selector: (context, screenShareEnabled) =>
                    deviceCtx.isScreenShareEnabled,
                builder: (context, screenShareEnabled, child) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          screenShareEnabled
                              ? LKColors.lkBlue
                              : Colors.grey.withOpacity(0.6)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(screenShareEnabled
                          ? LKColors.lkLightBlue
                          : Colors.grey),
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
                    onPressed: () => screenShareEnabled
                        ? deviceCtx.disableScreenShare()
                        : deviceCtx.enableScreenShare(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(screenShareEnabled
                            ? Icons.stop_screen_share_outlined
                            : Icons.screen_share_outlined),
                        const SizedBox(width: 2),
                        if (deviceScreenType != DeviceScreenType.mobile)
                          Text(
                            screenShareEnabled
                                ? 'Stop screen share '
                                : 'Screen share',
                            style: const TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
