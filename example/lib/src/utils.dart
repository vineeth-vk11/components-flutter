import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionDetails {
  final String serverUrl;
  final String roomName;
  final String participantToken;
  final String participantName;

  ConnectionDetails({
    required this.serverUrl,
    required this.roomName,
    required this.participantToken,
    required this.participantName,
  });

  factory ConnectionDetails.fromJson(Map<String, dynamic> json) {
    return ConnectionDetails(
      serverUrl: json['serverUrl'],
      roomName: json['roomName'],
      participantToken: json['participantToken'],
      participantName: json['participantName'],
    );
  }
}

Future<ConnectionDetails> fetchConnectionDetails(
    String name, String roomName) async {
  final response = await http.get(Uri.parse(
      'https://meet.staging.livekit.io/api/connection-details?roomName=$roomName&participantName=$name'));
  if (response.statusCode == 200) {
    return ConnectionDetails.fromJson(
        const JsonDecoder().convert(response.body));
  } else {
    throw Exception('Failed to load connection details');
  }
}
