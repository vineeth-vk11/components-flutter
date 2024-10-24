import 'package:flutter/material.dart';

import '../../context/room_context.dart';
import 'theme.dart';

class JoinButtonWidget extends StatelessWidget {
  JoinButtonWidget({
    Key? key,
    required this.roomCtx,
    required this.connected,
    this.onPressed,
  }) : super(key: key);

  RoomContext roomCtx;
  bool connected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed != null
          ? onPressed!()
          : !connected
              ? roomCtx.connect()
              : null,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(connected ? Colors.grey : LKColors.lkBlue),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
        ),
        padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
      ),
      child: const Text(
        'Join Room',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
