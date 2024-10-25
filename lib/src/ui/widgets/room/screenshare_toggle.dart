import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../context/media_device_context.dart';
import '../../../context/room_context.dart';
import '../theme.dart';

class ScreenShareToggleWidget extends StatelessWidget {
  const ScreenShareToggleWidget({
    super.key,
    required this.roomCtx,
    required this.deviceCtx,
    required this.screenShareEnabled,
    this.showLabel = false,
  });

  final bool screenShareEnabled;
  final bool showLabel;
  final RoomContext roomCtx;
  final MediaDeviceContext deviceCtx;

  @override
  Widget build(BuildContext context) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
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
          deviceScreenType == DeviceScreenType.desktop || lkPlatformIsDesktop()
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
          if (deviceScreenType != DeviceScreenType.mobile || showLabel)
            Text(
              screenShareEnabled ? 'Stop screen share ' : 'Screen share',
              style: const TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
}
