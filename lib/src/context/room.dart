import 'package:flutter/material.dart' hide ConnectionState;

import 'package:livekit_client/livekit_client.dart';

import '../ui/debug/logger.dart';
import 'chat.dart';
import 'media_device.dart';
import 'toast.dart';

class RoomContext extends ChangeNotifier
    with MediaDeviceContextMixin, ChatContextMixin, FToastMixin {
  RoomContext({
    String? url,
    String? token,
    bool connect = false,
    RoomOptions roomOptions = const RoomOptions(),
    ConnectOptions? connectOptions,
  })  : _url = url,
        _token = token,
        _connectOptions = connectOptions {
    _room = Room(roomOptions: roomOptions);
    _listener = _room.createListener();
    _listener
      ..on<RoomConnectedEvent>((event) {
        chatContextSetup(_listener, _room.localParticipant!);
        setRoom(_room);
        showConnectionStateToast(room.connectionState);
        _connected = true;
        _connecting = false;
        _roomMetadata = event.room.metadata;
        _activeRecording = event.room.isRecording;
        _roomName = event.room.name;
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        showConnectionStateToast(room.connectionState);
        setRoom(null);
        chatContextSetup(null, null);
        _connected = false;
        notifyListeners();
      })
      ..on<RoomMetadataChangedEvent>((event) {
        _roomMetadata = event.metadata;
        notifyListeners();
      })
      ..on<RoomRecordingStatusChanged>((event) {
        _activeRecording = event.activeRecording;
        notifyListeners();
      })
      ..on<ParticipantNameUpdatedEvent>((event) {
        _roomName = event.name;
        notifyListeners();
      })
      ..on<RoomEvent>((event) {
        [
          ParticipantConnectedEvent,
          ParticipantDisconnectedEvent,
          LocalTrackPublishedEvent,
          TrackPublishedEvent,
          TrackUnpublishedEvent
        ].contains(event.runtimeType)
            ? notifyListeners()
            : null;
      });

    loadDevices();

    if (connect && url != null && token != null) {
      this.connect(
        url: url,
        token: token,
      );
      _url = url;
      _token = token;
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

  ConnectionState get connectState => _room.connectionState;

  bool _connecting = false;
  bool get connecting => _connecting;

  bool _connected = false;
  bool get connected => _connected;

  int get participantCount => participants.length;

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

    showConnectionStateToast(ConnectionState.connecting);
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
      showConnectionStateToast(ConnectionState.disconnected);
      _connecting = false;
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _room.disconnect();
    notifyListeners();
  }

  List<Participant> get participants {
    if (!connected) {
      return [];
    }

    if (_room.localParticipant == null) {
      return _room.remoteParticipants.values.toList();
    }
    return <Participant>[
      _room.localParticipant!,
      ..._room.remoteParticipants.values,
    ];
  }

  void setFocusedTrack(String? sid) {
    _focusedTrackSid = sid;
    Debug.log('Focused track: $sid');
    notifyListeners();
  }

  String? _focusedTrackSid;
  String? get focusedTrackSid => _focusedTrackSid;

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}
