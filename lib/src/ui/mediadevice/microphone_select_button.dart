import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:livekit_components/src/context/media_device.dart';

import 'package:provider/provider.dart';

class MicrophoneSelectButton extends StatelessWidget {
  const MicrophoneSelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Row(children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                color: roomCtx.microphoneOpened
                    ? Colors.grey
                    : Colors.grey.withOpacity(0.6)),
            child: GestureDetector(
              onTap: () =>
                  roomCtx.setLocalAudioTrack(!roomCtx.microphoneOpened),
              child: FocusableActionDetector(
                child: Row(
                  children: [
                    Icon(roomCtx.microphoneOpened ? Icons.mic : Icons.mic_off),
                    const SizedBox(width: 4.0),
                    const Text('Microphone'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                color: Colors.grey.withOpacity(0.6)),
            child: Selector<RoomContext, String?>(
              selector: (context, roomCtx) =>
                  roomCtx.selectedAudioInputDeviceId,
              builder: (context, selectedAudioInputDeviceId, child) {
                return PopupMenuButton<MediaDevice>(
                  icon: const Icon(Icons.arrow_drop_down),
                  offset: const Offset(0, -65),
                  enabled: roomCtx.microphoneOpened,
                  itemBuilder: (BuildContext context) {
                    return [
                      if (roomCtx.audioInputs != null)
                        ...roomCtx.audioInputs!.map((device) {
                          return PopupMenuItem<MediaDevice>(
                            value: device,
                            child: ListTile(
                              selected: (device.deviceId ==
                                  selectedAudioInputDeviceId),
                              selectedColor: LKColors.lkBlue,
                              leading: (device.deviceId ==
                                      selectedAudioInputDeviceId)
                                  ? Icon(
                                      Icons.check_box_outlined,
                                      color: (device.deviceId ==
                                              selectedAudioInputDeviceId)
                                          ? LKColors.lkBlue
                                          : Colors.white,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.white,
                                    ),
                              title: Text(device.label),
                            ),
                            onTap: () => roomCtx.selectAudioInput(device),
                          );
                        })
                    ];
                  },
                );
              },
            ),
          ),
        ]);
      },
    );
  }
}
