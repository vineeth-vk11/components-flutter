import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/src/ui/debug/logger.dart';

class TrackContext extends ChangeNotifier {
  TrackContext(
    this._participant, {
    required this.pub,
  }) : _listener = _participant.createListener() {
    _listener
      ..on<TrackMutedEvent>((event) {
        if (event.publication.sid == pub?.sid) {
          Debug.event('TrackContext: TrackMutedEvent for ${_participant.sid}');
          notifyListeners();
        }
      })
      ..on<TrackUnmutedEvent>((event) {
        if (event.publication.sid == pub?.sid) {
          Debug.event(
              'TrackContext: TrackUnmutedEvent for ${_participant.sid}');
          notifyListeners();
        }
      })
      ..on<TrackStreamStateUpdatedEvent>((event) {
        if (event.publication.sid == pub?.sid) {
          Debug.event(
              'TrackContext: TrackStreamStateUpdatedEvent for ${_participant.sid}');
          notifyListeners();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
  }

  final Participant _participant;

  Participant get participant => _participant;
  final EventsListener<ParticipantEvent> _listener;

  final TrackPublication? pub;

  bool get isMuted => pub?.muted ?? true;

  VideoTrack? get videoTrack => pub?.track as VideoTrack?;

  AudioTrack? get audioTrack => pub?.track as AudioTrack?;

  bool get isScreenShare => pub?.source == TrackSource.screenShareVideo;

  String get sid => pub?.sid ?? '';
}
