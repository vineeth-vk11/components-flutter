import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';

import 'package:provider/provider.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  void _disableChat(roomCtx) async {
    await roomCtx.disableChat();
  }

  void _enableChat(roomCtx) async {
    await roomCtx.enableChat();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Selector<RoomContext, bool>(
        selector: (context, isChatEnabled) => roomCtx.isChatEnabled,
        builder: (context, isChatEnabled, child) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: isChatEnabled
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.6)),
                child: GestureDetector(
                  onTap: () => isChatEnabled
                      ? _disableChat(roomCtx)
                      : _enableChat(roomCtx),
                  child: const FocusableActionDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
                        ),
                        SizedBox(width: 4.0),
                        Text('Chat'),
                        /*Badge.count(
                          count: 2,
                          backgroundColor: LKColors.lkBlue,
                          child: const Text('Chat'),
                        ),*/
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
