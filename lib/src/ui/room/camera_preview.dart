import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import 'package:livekit_components/src/context/room.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<RoomContext, VideoTrack?>(
                selector: (context, track) => roomCtx.localVideoTrack,
                builder: (context, track, child) => track != null
                    ? Expanded(
                        child: VideoTrackRenderer(track),
                      )
                    : const Icon(
                        Icons.videocam_off,
                        color: Colors.grey,
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
