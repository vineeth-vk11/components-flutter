import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:livekit_components/livekit_components.dart';

class MicrophoneSelectButton extends StatelessWidget {
  const MicrophoneSelectButton({super.key, this.showLabel = false});

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Row(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(roomCtx.microphoneOpened
                  ? LKColors.lkBlue
                  : Colors.grey.withOpacity(0.6)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStateProperty.all(roomCtx.microphoneOpened
                  ? LKColors.lkLightBlue
                  : Colors.grey),
              shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)))),
              padding: WidgetStateProperty.all(
                deviceScreenType == DeviceScreenType.desktop ||
                        lkPlatformIsDesktop()
                    ? const EdgeInsets.fromLTRB(10, 20, 10, 20)
                    : const EdgeInsets.all(12),
              ),
            ),
            onPressed: () => roomCtx.microphoneOpened
                ? roomCtx.disableMicrophone()
                : roomCtx.enableMicrophone(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(roomCtx.microphoneOpened ? Icons.mic : Icons.mic_off),
                const SizedBox(width: 2),
                if (deviceScreenType != DeviceScreenType.mobile || showLabel)
                  const Text(
                    'Microphone',
                    style: TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 0.2),
          Selector<RoomContext, String?>(
            selector: (context, roomCtx) => roomCtx.selectedAudioInputDeviceId,
            builder: (context, selectedAudioInputDeviceId, child) {
              return PopupMenuButton<MediaDevice>(
                padding: const EdgeInsets.all(12),
                icon: const Icon(Icons.arrow_drop_down),
                offset: Offset(0, ((roomCtx.audioInputs?.length ?? 1) * -55.0)),
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
                enabled: roomCtx.microphoneOpened,
                itemBuilder: (BuildContext context) {
                  return [
                    if (roomCtx.audioInputs != null)
                      ...roomCtx.audioInputs!.map((device) {
                        return PopupMenuItem<MediaDevice>(
                          value: device,
                          child: ListTile(
                            selected:
                                (device.deviceId == selectedAudioInputDeviceId),
                            selectedColor: LKColors.lkBlue,
                            leading:
                                (device.deviceId == selectedAudioInputDeviceId)
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
        ]);
      },
    );
  }
}
