import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../theme.dart';

class ChatToggleWidget extends StatelessWidget {
  ChatToggleWidget({
    required this.isChatOpen,
    required this.toggleChat,
    this.showLabel = true,
  });

  final bool isChatOpen;
  final Function(bool enabled) toggleChat;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
            isChatOpen ? LKColors.lkBlue : Colors.grey.withOpacity(0.6)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(
            isChatOpen ? LKColors.lkLightBlue : Colors.grey),
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
      onPressed: () => toggleChat(!isChatOpen),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat_outlined),
          const SizedBox(width: 2),
          if (deviceScreenType != DeviceScreenType.mobile || showLabel)
            const Text(
              'Chat',
              style: TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
}
