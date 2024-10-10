import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:provider/provider.dart';

import 'ui/text_input.dart';

class Prejoin extends StatelessWidget {
  Prejoin({super.key, required this.onJoinPressed});

  final Function(String, String) onJoinPressed;

  String _name = '';

  String _roomName = 'livekit-room';

  void onTextNameChanged(String name) async {
    _name = name;
  }

  void onTextRoomNameChanged(String roomName) async {
    _roomName = roomName;
  }

  void _handleJoinPressed(BuildContext context) {
    onJoinPressed(_name, _roomName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) => Center(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MicrophoneSelectButton(),
                            CameraSelectButton(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: TextInput(
                          onTextChanged: onTextRoomNameChanged,
                          hintText: 'Enter room name',
                          text: _roomName,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: TextInput(
                          onTextChanged: onTextNameChanged,
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      height: 64,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: JoinButton(
                          onPressed: () => _handleJoinPressed(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
