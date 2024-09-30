import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:livekit_components/src/context/media_device.dart';
import 'package:provider/provider.dart';

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return ChangeNotifierProvider(
          create: (_) => roomCtx.mediaDevices,
          child: Container(
            width: 360,
            height: 240,
            color: LKColors.lkDarkBlue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Selector<MediaDevicesContext, LocalVideoTrack?>(
                    selector: (context, md) => md.localVideoTrack,
                    builder: (context, track, child) => track != null
                        ? Expanded(
                            child: VideoTrackRenderer(track),
                          )
                        : Expanded(
                            child: Center(
                              child: LayoutBuilder(
                                builder: (context, constraints) => Icon(
                                  Icons.videocam_off_outlined,
                                  color: LKColors.lkBlue,
                                  size: math.min(constraints.maxHeight,
                                          constraints.maxWidth) *
                                      0.33,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
