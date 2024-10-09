import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/src/ui/debug/logger.dart';

// topic: lk-chat-topic
class ChatMessage {
  final String message;
  final int timestamp;
  final String id;
  final bool sender;

  final Participant? participant;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.id,
    this.participant,
    required this.sender,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'timestamp': timestamp,
      'id': id,
    };
  }

  String toJson() => const JsonEncoder().convert(toMap());

  factory ChatMessage.fromJsonString(String source, Participant? participant) =>
      ChatMessage.fromMap(const JsonDecoder().convert(source), participant);

  factory ChatMessage.fromMap(
      Map<String, dynamic> map, Participant? participant) {
    return ChatMessage(
      message: map['message'],
      timestamp: map['timestamp'],
      id: map['id'],
      participant: participant,
      sender: false,
    );
  }
}

mixin ChatContextMixin on ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  LocalParticipant? _localParticipant;

  void chatContextSetup(
      EventsListener<RoomEvent> listener, LocalParticipant localParticipant) {
    listener.on<DataReceivedEvent>((event) {
      var str = utf8.decode(Uint8List.fromList(event.data));
      Debug.log('DataReceivedEvent $str');
      addMessageFromMap(str, event.participant);
    });
    _localParticipant = localParticipant;
  }

  void sendMessage(String message) {
    final msg = ChatMessage(
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: true,
    );
    addMessage(msg);
    _localParticipant?.publishData(const Utf8Encoder().convert(msg.toJson()),
        topic: 'lk-chat-topic');
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void addMessageFromMap(String buf, Participant? participant) {
    final message = ChatMessage.fromJsonString(buf, participant);
    addMessage(message);
  }
}
