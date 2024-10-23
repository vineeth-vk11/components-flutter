import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../../types/types.dart';

class LivekitRoom extends StatefulWidget {
  const LivekitRoom(
      {super.key, required this.roomContext, required this.builder});

  final RoomContext roomContext;
  final WidgetBuilder builder;

  @override
  State<LivekitRoom> createState() => LivekitRoomState();
}

class LivekitRoomState extends State<LivekitRoom> {
  @override
  void initState() {
    super.initState();

    widget.roomContext.initFToast();
  }

  @override
  void dispose() {
    widget.roomContext.deinitFToast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => widget.roomContext,
      child: widget.builder(context),
    );
  }
}
