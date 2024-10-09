import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart';
import 'package:livekit_components/src/context/chat.dart';

import 'package:provider/provider.dart';

import 'package:chat_bubbles/chat_bubbles.dart';

import 'data_chip.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  List<Widget> _buildMessages(List<ChatMessage> messages) {
    List<Widget> msgWidgets = [];
    int lastTimestamp = 0;
    String lastPartcipantId = '';
    for (ChatMessage msg in messages) {
      if (msg.timestamp - lastTimestamp > 3000 || lastPartcipantId != msg.id) {
        msgWidgets.add(CustomDateChip(
            date: DateTime.fromMillisecondsSinceEpoch(msg.timestamp)));
      }
      msgWidgets.add(BubbleNormal(
        text: msg.message,
        color: const Color(0xFFE8E8EE),
        tail: false,
        isSender: msg.sender,
      ));

      lastTimestamp = msg.timestamp;
      lastPartcipantId = msg.id;
    }
    return msgWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Container(
        color: LKColors.lkDarkBlue,
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            Container(
              height: 50.0,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Messages',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      roomCtx.disableChat();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Selector<RoomContext, List<ChatMessage>>(
                  selector: (context, messages) => roomCtx.messages,
                  builder: (context, messages, child) => Column(
                    children: _buildMessages(messages),
                  ),
                ),
              ),
            ),
            Container(
              color: LKColors.lkDarkBlue,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: MessageBar(
                messageBarColor: LKColors.lkDarkBlue,
                replyWidgetColor: LKColors.lkDarkBlue,
                onSend: (msg) => roomCtx.sendMessage(msg),
              ),
            )
          ],
        ),
      );
    });
  }
}
