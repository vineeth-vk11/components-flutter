import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class ChatToggleButton extends StatelessWidget {
  const ChatToggleButton({super.key});

  void _disableChat(roomCtx) async {
    await roomCtx.disableChat();
  }

  void _enableChat(roomCtx) async {
    await roomCtx.enableChat();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
          selector: (context, enabled) => roomCtx.isChatEnabled,
          builder: (context, enabled, child) => IconButton(
                onPressed: () =>
                    enabled ? _disableChat(roomCtx) : _enableChat(roomCtx),
                icon: const Icon(Icons.chat),
                tooltip: 'Chat',
              ));
    });
  }
}
