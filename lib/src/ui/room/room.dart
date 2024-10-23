import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class LivekitRoom extends StatelessWidget {
  const LivekitRoom(
      {super.key, required this.roomContext, required this.builder});

  final RoomContext roomContext;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => roomContext,
      child: builder(context),
    );
  }
}
