import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class RoomContext extends ChangeNotifier {
  RoomContext({
    required this.url,
    required this.token,
    RoomOptions roomOptions = const RoomOptions(),
  }) {
    room = Room(roomOptions: roomOptions);
    _listener = room.createListener();
    _listener
      ..on<RoomConnectedEvent>((event) {
        _connected = true;
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        _connected = false;
        notifyListeners();
      })
      ..on<ParticipantConnectedEvent>((event) {
        addParticipant(event.participant);
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        removeParticipant(event.participant);
      })
      ..on<TrackPublishedEvent>((event) {
        addTrack(event.publication);
      })
      ..on<TrackUnpublishedEvent>((event) {
        removeTrack(event.publication);
      });
  }

  Future<void> connect() async {
    await room.connect(url, token);
    notifyListeners();
  }

  Future<void> disconnect() async {
    await room.disconnect();
    notifyListeners();
  }

  FastConnectOptions? _fastConnectOptions;

  FastConnectOptions? get fastConnectOptions => _fastConnectOptions;

  set fastConnectOptions(FastConnectOptions? value) {
    _fastConnectOptions = value;
    notifyListeners();
  }

  late EventsListener<RoomEvent> _listener;

  final String url;

  final String token;

  late Room room;

  String? get roomName => room.name;

  final List<Participant> participants = [];

  final List<TrackPublication> tracks = [];

  List<LocalTrackPublication> get localTracks =>
      tracks.whereType<LocalTrackPublication>().toList();

  List<RemoteTrackPublication> get remoteTracks =>
      tracks.whereType<RemoteTrackPublication>().toList();

  bool _connected = false;
  bool get connected => _connected;

  void addParticipant(Participant participant) {
    participants.add(participant);
    notifyListeners();
  }

  void removeParticipant(Participant participant) {
    participants.remove(participant);
    notifyListeners();
  }

  void addTrack(TrackPublication track) {
    tracks.add(track);
    notifyListeners();
  }

  void removeTrack(TrackPublication track) {
    tracks.remove(track);
    notifyListeners();
  }
}
