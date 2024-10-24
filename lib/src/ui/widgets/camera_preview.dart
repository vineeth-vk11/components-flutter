import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';

import 'theme.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required this.track,
  });
  final LocalVideoTrack? track;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 240,
      color: LKColors.lkDarkBlue,
      child: Center(
        child: track != null
            ? VideoTrackRenderer(track!)
            : Center(
                child: LayoutBuilder(
                  builder: (context, constraints) => Icon(
                    Icons.videocam_off_outlined,
                    color: LKColors.lkBlue,
                    size:
                        math.min(constraints.maxHeight, constraints.maxWidth) *
                            0.33,
                  ),
                ),
              ),
      ),
    );
  }
}
