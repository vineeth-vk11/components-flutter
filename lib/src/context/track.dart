import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class TrackContext extends ValueNotifier {
  TrackContext(
    this._participant, {
    required this.isScreenShare,
  }) : super(null);
  final Participant _participant;
  Participant get participant => _participant;
  List<TrackPublication> get tracks =>
      _participant.trackPublications.values.toList();
  final bool isScreenShare;
  VideoTrack? get videoTrack => tracks
      .where((t) => t.source == TrackSource.camera && !t.muted)
      .firstOrNull
      ?.track as VideoTrack?;
  VideoTrack? get screenTrack => tracks
      .where((t) => t.source == TrackSource.screenShareVideo && !t.muted)
      .firstOrNull
      ?.track as VideoTrack?;
}
