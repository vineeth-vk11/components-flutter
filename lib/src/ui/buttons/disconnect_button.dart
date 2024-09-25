import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
          selector: (context, connected) => roomCtx.connected,
          builder: (context, connected, child) => IconButton(
                disabledColor: Colors.grey,
                color: connected ? Colors.red : Colors.grey,
                onPressed: () => connected ? roomCtx.disconnect() : null,
                icon: const Icon(Icons.close),
                tooltip: connected ? 'Disconnect' : '',
              ));
    });
  }
}
