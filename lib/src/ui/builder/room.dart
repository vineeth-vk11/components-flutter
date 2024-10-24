import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room_context.dart';

typedef RoomContextBuilder = Widget Function(
    BuildContext context, RoomContext roomCtx);

class LivekitRoom extends StatelessWidget {
  const LivekitRoom(
      {super.key, required this.roomContext, required this.builder});

  final RoomContext roomContext;
  final RoomContextBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => roomContext,
      child: Consumer<RoomContext>(
        builder: (context, roomCtx, child) => builder(context, roomCtx),
      ),
    );
  }
}
