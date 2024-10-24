import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room_context.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key, required this.builder});

  final Function(BuildContext context, RoomContext roomCtx, bool connected)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Selector<RoomContext, bool>(
          selector: (context, connected) => roomCtx.connected,
          builder: (context, connected, child) =>
              builder(context, roomCtx, connected),
        );
      },
    );
  }
}
