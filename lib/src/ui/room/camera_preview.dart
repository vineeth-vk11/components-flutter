import 'package:flutter/material.dart';
import 'package:livekit_components/src/context/room.dart';
import 'package:provider/provider.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: const Center(
          child: Text('Camera Preview'),
        ),
      );
    });
  }
}
