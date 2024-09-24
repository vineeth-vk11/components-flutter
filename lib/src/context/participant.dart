import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class ParticipantContext extends ChangeNotifier {
  ParticipantContext(this._participant)
      : _listener = _participant.createListener() {
    _listener
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

  final Participant _participant;
  Participant get participant => _participant;

  List<TrackPublication> get tracks =>
      _participant.trackPublications.values.toList();

  String? get metadata => _participant.metadata;

  ParticipantPermissions? get permissions => _participant.permissions;

  String? get name => _participant.name;

  bool get muted => _participant.isMuted;

  final EventsListener<ParticipantEvent> _listener;

  void addTrack(TrackPublication publication) {
    notifyListeners();
  }

  void removeTrack(TrackPublication publication) {
    notifyListeners();
  }
}
