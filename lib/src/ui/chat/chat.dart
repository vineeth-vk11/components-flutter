import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/livekit_components.dart';

import 'package:provider/provider.dart';

import 'package:chat_bubbles/chat_bubbles.dart';

DateTime now = DateTime.now();

// topic: lk-chat-topic
class ChatMessage {
  final String message;
  final int timestamp;
  final String id;

  final Participant? participant;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.id,
    this.participant,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'timestamp': timestamp,
      'id': id,
    };
  }

  String toJson() => const JsonEncoder().convert(toMap());

  factory ChatMessage.fromMap(
      Map<String, dynamic> map, Participant? participant) {
    return ChatMessage(
      message: map['message'],
      timestamp: map['timestamp'],
      id: map['id'],
      participant: participant,
    );
  }
}

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(builder: (context, roomCtx, child) {
      return Container(
        color: LKColors.lkDarkBlue,
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DateChip(
                    date: DateTime(now.year, now.month, now.day - 2),
                  ),
                  const BubbleSpecialThree(
                    text: 'bubble special three without tail',
                    color: Color(0xFFE8E8EE),
                    tail: false,
                    isSender: false,
                  ),
                  BubbleNormal(
                    text: 'bubble normal without tail',
                    color: const Color(0xFFE8E8EE),
                    tail: false,
                    sent: true,
                    seen: true,
                    delivered: true,
                  ),
                  DateChip(
                    date: DateTime(now.year, now.month, now.day - 1),
                  ),
                  const BubbleSpecialOne(
                    text: 'bubble special one without tail',
                    tail: false,
                    color: Color(0xFFE8E8EE),
                    sent: true,
                  ),
                  DateChip(
                    date: now,
                  ),
                  const BubbleSpecialTwo(
                    text: 'bubble special tow without tail',
                    tail: false,
                    color: Color(0xFFE8E8EE),
                    delivered: true,
                  ),
                  const BubbleSpecialThree(
                    text: 'Alice:\nbubble special three without tail',
                    color: Color(0xFFE8E8EE),
                    tail: false,
                    isSender: false,
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            MessageBar(
              messageBarColor: LKColors.lkDarkBlue,
              replyWidgetColor: LKColors.lkDarkBlue,
              onSend: (_) => print(_),
            ),
          ],
        ),
      );
    });
  }
}
