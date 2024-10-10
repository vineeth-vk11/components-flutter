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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(roomCtx.cameraOpened
                    ? LKColors.lkBlue
                    : Colors.grey.withOpacity(0.6)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                overlayColor: WidgetStateProperty.all(
                    roomCtx.cameraOpened ? LKColors.lkLightBlue : Colors.grey),
                shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)))),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(10, 20, 10, 20)),
              ),
              onPressed: () => roomCtx.cameraOpened
                  ? roomCtx.disableCamera()
                  : roomCtx.enableCamera(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(roomCtx.cameraOpened
                      ? Icons.videocam
                      : Icons.videocam_off),
                  const Text('Camera'),
                ],
              ),
            ),
            const SizedBox(width: 0.2),
            Selector<RoomContext, String?>(
              selector: (context, roomCtx) =>
                  roomCtx.selectedVideoInputDeviceId,
              builder: (context, selectedVideoInputDeviceId, child) {
                return PopupMenuButton<MediaDevice>(
                  padding: const EdgeInsets.all(12),
                  offset:
                      Offset(0, ((roomCtx.videoInputs?.length ?? 1) * -55.0)),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.grey.withOpacity(0.6)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    overlayColor: WidgetStateProperty.all(Colors.grey),
                    elevation: WidgetStateProperty.all(20),
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)))),
                  ),
                  enabled: roomCtx.cameraOpened,
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
          ],
        );
      },
    );
  }
}
