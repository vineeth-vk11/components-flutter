import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/room_context.dart';

class ChatToggle extends StatelessWidget {
  const ChatToggle({super.key, required this.builder});

  final Widget Function(
      BuildContext context, RoomContext roomCtx, bool isChatEnabled) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, isChatEnabled) => roomCtx.isChatEnabled,
        builder: (context, isChatEnabled, child) =>
            builder(context, roomCtx, isChatEnabled),
      );
    });
  }
}
