import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../../types/theme.dart';

class CameraSelectButton extends StatelessWidget {
  const CameraSelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                  color: roomCtx.cameraOpened
                      ? Colors.grey
                      : Colors.grey.withOpacity(0.6)),
              child: GestureDetector(
                onTap: () => roomCtx.setLocalVideoTrack(!roomCtx.cameraOpened),
                child: FocusableActionDetector(
                  child: Row(
                    children: [
                      Icon(roomCtx.cameraOpened
                          ? Icons.videocam
                          : Icons.videocam_off),
                      const SizedBox(width: 4.0),
                      const Text('Camera'),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  color: Colors.grey.withOpacity(0.6)),
              child: Selector<RoomContext, String?>(
                selector: (context, md) => roomCtx.selectedVideoInputDeviceId,
                builder: (context, selectedVideoInputDeviceId, child) {
                  return PopupMenuButton<MediaDevice>(
                    enabled: roomCtx.cameraOpened,
                    icon: const Icon(Icons.arrow_drop_down),
                    offset: const Offset(0, -65),
                    itemBuilder: (BuildContext context) {
                      return [
                        if (roomCtx.videoInputs != null)
                          ...roomCtx.videoInputs!.map((device) {
                            return PopupMenuItem<MediaDevice>(
                              value: device,
                              child: ListTile(
                                selected: (device.deviceId ==
                                    selectedVideoInputDeviceId),
                                selectedColor: LKColors.lkBlue,
                                leading: (device.deviceId ==
                                        selectedVideoInputDeviceId)
                                    ? Icon(
                                        Icons.check_box_outlined,
                                        color: (device.deviceId ==
                                                selectedVideoInputDeviceId)
                                            ? LKColors.lkBlue
                                            : Colors.white,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: Colors.white,
                                      ),
                                title: Text(device.label),
                              ),
                              onTap: () => roomCtx.selectVideoInput(device),
                            );
                          })
                      ];
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
