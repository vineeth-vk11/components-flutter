import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const EdgeInsets.fromLTRB(10, 20, 10, 20)),
            ),
            onPressed: () => connected ? roomCtx.disconnect() : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 2),
                Text(
                  'Leave',
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
