import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/chat_context.dart';
import '../../context/room_context.dart';

class ChatBuilder extends StatelessWidget {
  const ChatBuilder({
    super.key,
    required this.builder,
  });

  final Function(BuildContext context, bool enabled, ChatContextMixin chatCtx,
      List<ChatMessage> messages) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return builder(
        context,
        roomCtx.isChatEnabled,
        roomCtx,
        roomCtx.messages,
      );
    });
  }
}
