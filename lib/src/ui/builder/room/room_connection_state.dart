import 'package:flutter/material.dart' hide ConnectionState;

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../../context/room_context.dart';
import '../../../debug/logger.dart';

class RoomConnectionState extends StatelessWidget {
  const RoomConnectionState({
    Key? key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ConnectionState connectionState)
      builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      Debug.log(
          '====>        RoomConnectionState for ${roomCtx.connectionState}');
      return Selector<RoomContext, ConnectionState>(
        selector: (context, connectionState) => roomCtx.connectionState,
        builder: (context, connectionState, child) {
          return builder(context, connectionState);
        },
      );
    });
  }
}
