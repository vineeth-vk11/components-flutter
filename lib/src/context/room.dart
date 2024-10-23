import 'dart:async';

import 'package:flutter/material.dart' hide ConnectionState;

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../ui/debug/logger.dart';
import 'chat.dart';

class RoomContext extends ChangeNotifier with ChatContextMixin {
  /// Get the [RoomContext] from the [context].
  /// this method must be called under the [LivekitRoom] widget.
  static RoomContext? of(BuildContext context) {
    return Provider.of<RoomContext?>(context);
  }

  /// Get the [ChatContextMixin] from the [context].
  /// this method must be called under the [LivekitRoom] widget.
  static ChatContextMixin? chatOf(BuildContext context) {
    return Provider.of<RoomContext?>(context);
  }

  RoomContext({
    String? url,
    String? token,
    Room? room,
    bool connect = false,
    RoomOptions roomOptions = const RoomOptions(),
    ConnectOptions? connectOptions,
  })  : _url = url,
        _token = token,
        _connectOptions = connectOptions {
    _room = room ?? Room(roomOptions: roomOptions);
    _listener = _room.createListener();
    _listener
      ..on<RoomConnectedEvent>((event) {
        Debug.event('RoomContext: RoomConnectedEvent');
        chatContextSetup(_listener, _room.localParticipant!);
        _connectionState = _room.connectionState;
        _connected = true;
        _connecting = false;
        _roomMetadata = event.room.metadata;
        _activeRecording = event.room.isRecording;
        _roomName = event.room.name;
        sortParticipants();
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        Debug.event('RoomContext: RoomDisconnectedEvent');
        _connectionState = _room.connectionState;
        chatContextSetup(null, null);
        _connected = false;
        _participants.clear();
        notifyListeners();
      })
      ..on<RoomReconnectedEvent>((event) {
        Debug.event('RoomContext: RoomReconnectedEvent');
        _connectionState = _room.connectionState;
        notifyListeners();
      })
      ..on<RoomReconnectingEvent>((event) {
        Debug.event('RoomContext: RoomReconnectingEvent');
        _connectionState = _room.connectionState;
        notifyListeners();
      })
      ..on<RoomMetadataChangedEvent>((event) {
        Debug.event(
            'RoomContext: RoomMetadataChangedEvent metadata = ${event.metadata}');
        _roomMetadata = event.metadata;
        notifyListeners();
      })
      ..on<RoomRecordingStatusChanged>((event) {
        Debug.event(
            'RoomContext: RoomRecordingStatusChanged activeRecording = ${event.activeRecording}');
        _activeRecording = event.activeRecording;
        notifyListeners();
      })
      ..on<ParticipantNameUpdatedEvent>((event) {
        Debug.event(
            'RoomContext: ParticipantNameUpdatedEvent name = ${event.name}');
        _roomName = event.name;
        notifyListeners();
      })
      ..on<ParticipantConnectedEvent>((event) {
        Debug.event(
            'RoomContext: ParticipantConnectedEvent participant = ${event.participant.identity}');
        sortParticipants();
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        Debug.event(
            'RoomContext: ParticipantDisconnectedEvent participant = ${event.participant.identity}');
        _participants
            .removeWhere((p) => p.identity == event.participant.identity);
        notifyListeners();
      })
      ..on<TrackPublishedEvent>((event) {
        Debug.event('ParticipantContext: TrackPublishedEvent');
        sortParticipants();
      })
      ..on<TrackUnpublishedEvent>((event) {
        Debug.event('ParticipantContext: TrackUnpublishedEvent');
        sortParticipants();
      })
      ..on<LocalTrackPublishedEvent>((event) {
        Debug.event(
            'RoomContext: LocalTrackPublishedEvent track = ${event.publication.sid}');
        sortParticipants();
      })
      ..on<LocalTrackUnpublishedEvent>((event) {
        Debug.event(
            'RoomContext: LocalTrackUnpublishedEvent track = ${event.publication.sid}');
        sortParticipants();
      });

    if (connect && url != null && token != null) {
      _url = url;
      _token = token;
      this.connect(url: url, token: token);
    }
  }

  final ConnectOptions? _connectOptions;
  FastConnectOptions? _fastConnectOptions;
  late EventsListener<RoomEvent> _listener;

  String? _url;
  String? _token;
  late Room _room;

  Room get room => _room;

  String? _roomName;
  String? get roomName => _roomName;

  String? _roomMetadata;
  String? get roomMetadata => _roomMetadata;

  bool _activeRecording = false;
  bool get activeRecording => _activeRecording;

  ConnectionState _connectionState = ConnectionState.disconnected;
  ConnectionState get connectionState => _connectionState;

  bool _connecting = false;
  bool get connecting => _connecting;

  bool _connected = false;
  bool get connected => _connected;

  int get participantCount => _participants.length;

  final List<Participant> _participants = [];
  List<Participant> get participants => _participants;

  void sortParticipants() {
    _participants.clear();

    if (!connected) {
      return;
    }

    if (_room.localParticipant != null) {
      _participants.add(_room.localParticipant!);
    }

    _participants.addAll(_room.remoteParticipants.values);
    notifyListeners();
  }

  Future<void> connect({
    String? url,
    String? token,
  }) async {
    if (cameraOpened || microphoneOpened) {
      _fastConnectOptions = FastConnectOptions(
        microphone: TrackOption(track: localAudioTrack!),
        camera: TrackOption(track: localVideoTrack!),
      );
      await resetLocalTracks();
    }

    _connectionState = ConnectionState.connecting;
    _connecting = true;
    notifyListeners();

    try {
      await _room.connect(
        url ?? _url!,
        token ?? _token!,
        fastConnectOptions: _fastConnectOptions,
        connectOptions: _connectOptions,
      );
      _url ??= url;
      _token ??= token;
      _connecting = false;
    } catch (e) {
      _connectionState = ConnectionState.disconnected;
      _connecting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _room.disconnect();
    notifyListeners();
  }

  void setFocusedTrack(String? sid) {
    _focusedTrackSid = sid;
    Debug.log('Focused track: $sid');
    notifyListeners();
  }

  String? _focusedTrackSid;
  String? get focusedTrackSid => _focusedTrackSid;

  LocalVideoTrack? _localVideoTrack;

  LocalVideoTrack? get localVideoTrack => _localVideoTrack;

  set localVideoTrack(LocalVideoTrack? track) {
    _localVideoTrack = track;
    notifyListeners();
  }

  bool get cameraOpened => isCameraEnabled ?? _localVideoTrack != null;

  bool? get isCameraEnabled => _room.localParticipant?.isCameraEnabled();

  LocalAudioTrack? _localAudioTrack;

  LocalAudioTrack? get localAudioTrack => _localAudioTrack;

  set localAudioTrack(LocalAudioTrack? track) {
    _localAudioTrack = track;
    notifyListeners();
  }

  bool get microphoneOpened => isMicrophoneEnabled ?? _localAudioTrack != null;

  bool? get isMicrophoneEnabled =>
      _room.localParticipant?.isMicrophoneEnabled();

  Future<void> resetLocalTracks() async {
    _localAudioTrack = null;
    _localVideoTrack = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}
