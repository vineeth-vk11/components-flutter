import 'package:flutter/foundation.dart';

import 'package:livekit_client/livekit_client.dart';

class ParticipantContext extends ChangeNotifier {
  ParticipantContext(this._participant)
      : _listener = _participant.createListener() {
    _listener
      ..on<LocalTrackPublishedEvent>((event) {
        notifyListeners();
      })
      ..on<LocalTrackUnpublishedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackPublishedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackUnpublishedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackSubscribedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackUnsubscribedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackE2EEStateEvent>((event) {
        notifyListeners();
      })
      ..on<SpeakingChangedEvent>((event) {
        _isSpeaking = event.speaking;
        notifyListeners();
      })
      ..on<TrackMutedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackUnmutedEvent>((event) {
        notifyListeners();
      })
      ..on<ParticipantConnectionQualityUpdatedEvent>((event) {
        notifyListeners();
      })
      ..on<TrackE2EEStateEvent>((event) {
        notifyListeners();
      })
      ..on<TranscriptionEvent>((e) {
        for (var seg in e.segments) {
          print('Transcription: ${seg.text} ${seg.isFinal}');
        }
      });
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  bool get isMuted => _participant.isMuted;

  ConnectionQuality get connectionQuality => _participant.connectionQuality;

  bool get isEncrypted =>
      _participant.trackPublications.isNotEmpty && _participant.isEncrypted;

  bool get isLocal => _participant is LocalParticipant;

  final Participant _participant;
  Participant get participant => _participant;

  List<TrackPublication> get tracks =>
      _participant.trackPublications.values.toList();

  List<VideoTrack> get videoTracks => tracks
      .where((element) =>
          element.kind == TrackType.VIDEO &&
          element.track != null &&
          !element.muted)
      .map(
        (e) => e.track as VideoTrack,
      )
      .toList();

  String get sid => _participant.sid;

  String get identity => _participant.identity;

  String? get metadata => _participant.metadata;

  ParticipantPermissions? get permissions => _participant.permissions;

  String get name =>
      _participant.name != '' ? _participant.name : _participant.identity;

  bool get muted => _participant.isMuted;

  final EventsListener<ParticipantEvent> _listener;
}
