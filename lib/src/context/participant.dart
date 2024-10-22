import 'package:flutter/foundation.dart';

import 'package:livekit_client/livekit_client.dart';

import '../ui/debug/logger.dart';

class ParticipantContext extends ChangeNotifier {
  ParticipantContext(this._participant)
      : _listener = _participant.createListener() {
    _listener
      ..on<SpeakingChangedEvent>((event) {
        _isSpeaking = event.speaking;
        notifyListeners();
      })
      ..on<ParticipantNameUpdatedEvent>((event) {
        _name = event.name;
        notifyListeners();
      })
      ..on<ParticipantMetadataUpdatedEvent>((event) {
        _metadata = event.metadata;
        notifyListeners();
      })
      ..on<TrackMutedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackUnmutedEvent>((event) {
        notifyListeners();
      })
      ..on<ParticipantConnectionQualityUpdatedEvent>((event) {
        _connectionQuality = event.connectionQuality;
        notifyListeners();
      })
      ..on<ParticipantPermissionsUpdatedEvent>((event) {
        _permissions = event.permissions;
        notifyListeners();
      })
      ..on<TranscriptionEvent>((e) {
        for (var seg in e.segments) {
          Debug.log('Transcription: ${seg.text} ${seg.isFinal}');
        }
      })
      ..on<ParticipantAttributesChanged>((event) {
        _attributes = event.attributes;
        notifyListeners();
      });

    _name = _participant.name;
    _metadata = _participant.metadata;
    _connectionQuality = _participant.connectionQuality;
    _permissions = _participant.permissions;
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
  }

  bool get isLocal => _participant is LocalParticipant;

  List<TrackPublication> get tracks =>
      _participant.trackPublications.values.toList();

  final Participant _participant;
  final EventsListener<ParticipantEvent> _listener;

  bool get isEncrypted =>
      _participant.trackPublications.isNotEmpty && _participant.isEncrypted;

  String get identity => _participant.identity;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  ConnectionQuality _connectionQuality = ConnectionQuality.good;
  ConnectionQuality get connectionQuality => _connectionQuality;

  String? _metadata;
  String? get metadata => _metadata;

  String _name = '';
  String get name => _name;

  bool get isMuted => _participant.isMuted;

  ParticipantPermissions? _permissions;
  ParticipantPermissions? get permissions => _permissions;

  Map<String, String> _attributes = {};
  Map<String, String> get attributes => _attributes;
}
