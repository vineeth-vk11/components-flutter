import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/room.dart';
import '../buttons/camera_select_button.dart';
import '../buttons/join_button.dart';
import '../buttons/microphone_select_button.dart';
import '../debug/logger.dart';
import 'camera_preview.dart';
import 'text_input.dart';

class Prejoin extends StatelessWidget {
  Prejoin(
      {super.key, required this.token, required this.url, this.onJoinPressed});

  final Function(RoomContext roomCtx, String url, String token)? onJoinPressed;

  String token;

  String url;

  void onTextTokenChanged(String token) async {
    token = token;
  }

  void onTextUrlChanged(String url) async {
    url = url;
  }

  void _handleJoinPressed(RoomContext roomCtx) async {
    if (onJoinPressed == null) {
      Debug.event('Joining room: $url');
      try {
        await roomCtx.connect(
          url: url,
          token: token,
        );
      } catch (e) {
        Debug.event('Failed to join room: $e');
      }
      return;
    }
    onJoinPressed?.call(roomCtx, url, token);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) => !roomCtx.connected &&
              !roomCtx.connecting
          ? Center(
              child: SizedBox(
                width: 480,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const CameraPreview(),
                          ),
                          SizedBox(
                            width: 360,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MicrophoneSelectButton(
                                    showLabel: true,
                                  ),
                                  CameraSelectButton(
                                    showLabel: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 360,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              child: TextInput(
                                onTextChanged: onTextUrlChanged,
                                hintText: 'Enter Livekit Server URL',
                                text: url,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 360,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              child: TextInput(
                                onTextChanged: onTextTokenChanged,
                                hintText: 'Enter Token',
                                text: token,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 360,
                            height: 64,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: JoinButton(
                                onPressed: () => _handleJoinPressed(roomCtx),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(width: 0, height: 0),
    );
  }
}
