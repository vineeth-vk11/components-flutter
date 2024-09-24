import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class RoomContext extends ChangeNotifier {
  RoomContext({
    required String url,
    required String token,
    RoomOptions roomOptions = const RoomOptions(),
    ConnectOptions? connectOptions,
  })  : _url = url,
        _token = token,
        _connectOptions = connectOptions {
    _room = Room(roomOptions: roomOptions);
    _listener = _room.createListener();
    _listener
      ..on<RoomConnectedEvent>((event) {
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
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
  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    await _room.connect(
      _url,
      _token,
      fastConnectOptions: _fastConnectOptions,
      connectOptions: _connectOptions,
    );
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _room.disconnect();
    notifyListeners();
  }

  final ConnectOptions? _connectOptions;

  FastConnectOptions? _fastConnectOptions;

  FastConnectOptions? get fastConnectOptions => _fastConnectOptions;

  set fastConnectOptions(FastConnectOptions? value) {
    _fastConnectOptions = value;
    notifyListeners();
  }

  late EventsListener<RoomEvent> _listener;

  final String _url;

  final String _token;

  Room get room => _room;

  late Room _room;

  bool get isMicrophoneEnabled =>
      _room.localParticipant?.isMicrophoneEnabled() ?? false;

  String? get roomName => _room.name;

  String? get roomMetadata => _room.metadata;

  int get participantCount => participants.length;

  final List<Participant> participants = [];

  final List<TrackPublication> tracks = [];

  List<LocalTrackPublication> get localTracks =>
      tracks.whereType<LocalTrackPublication>().toList();

  List<RemoteTrackPublication> get remoteTracks =>
      tracks.whereType<RemoteTrackPublication>().toList();

  ConnectionState get connectState => _room.connectionState;

  bool get connected => _room.connectionState == ConnectionState.connected;

  void enableMicrophone() {
    _room.localParticipant?.setMicrophoneEnabled(true);
    notifyListeners();
  }

  void disableMicrophone() {
    _room.localParticipant?.setMicrophoneEnabled(false);
    notifyListeners();
  }

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
