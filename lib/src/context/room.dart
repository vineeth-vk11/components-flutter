import 'package:flutter/material.dart' hide ConnectionState;

import 'package:livekit_client/livekit_client.dart';

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
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        showConnectionStateToast(room.connectionState);
        setRoom(null);
        chatContextSetup(null, null);
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

  String? get roomName => _room.name;
  String? get roomMetadata => _room.metadata;

  ConnectionState get connectState => _room.connectionState;
  bool get connected => _room.connectionState == ConnectionState.connected;
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

    await _room.connect(
      _url ?? url!,
      _token ?? token!,
      fastConnectOptions: _fastConnectOptions,
      connectOptions: _connectOptions,
    );

    _url ??= url;
    _token ??= token;
    notifyListeners();
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

  bool _chatEnabled = false;
  bool get isChatEnabled => _chatEnabled;

  void enableChat() {
    _chatEnabled = true;
    notifyListeners();
  }

  void disableChat() {
    _chatEnabled = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}
