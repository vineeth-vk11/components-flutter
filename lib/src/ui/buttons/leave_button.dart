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
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color:
                        connected ? Colors.red : Colors.grey.withOpacity(0.6)),
                child: GestureDetector(
                  onTap: () => connected ? roomCtx.disconnect() : null,
                  child: const FocusableActionDetector(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 4.0),
                        Text('Leave'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
