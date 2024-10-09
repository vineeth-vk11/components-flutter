import 'package:flutter/material.dart';
import 'package:livekit_components/src/context/media_device.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';

class ScreenShareButton extends StatelessWidget {
  const ScreenShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, screenShareEnabled) => roomCtx.isScreenShareEnabled,
        builder: (context, screenShareEnabled, child) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: screenShareEnabled
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.6)),
                child: GestureDetector(
                  onTap: () => screenShareEnabled
                      ? roomCtx.disableScreenShare()
                      : roomCtx.enableScreenShare(context),
                  child: const FocusableActionDetector(
                    child: Row(
                      children: [
                        Icon(Icons.screen_share_outlined),
                        SizedBox(width: 4.0),
                        Text('Screen Share'),
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
