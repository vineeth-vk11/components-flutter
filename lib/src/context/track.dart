import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class TrackContext extends ChangeNotifier {
  TrackContext(
    this._participant, {
    required this.pub,
  }) : _listener = _participant.createListener() {
    _listener
      ..on<TrackMutedEvent>((event) {
        _isMuted = true;
        notifyListeners();
      })
      ..on<TrackUnmutedEvent>((event) {
        _isMuted = false;
        notifyListeners();
      });

    _isMuted = _participant.isMuted;
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
  }

  final Participant _participant;
  final EventsListener<ParticipantEvent> _listener;

  final TrackPublication? pub;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  VideoTrack? get videoTrack => pub?.track as VideoTrack?;

  bool get isScreenShare => pub?.source == TrackSource.screenShareVideo;

  String get sid => pub?.sid ?? '';
}
