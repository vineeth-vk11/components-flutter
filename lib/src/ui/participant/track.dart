import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_components/src/context/participant.dart';

class TrackContext extends ParticipantContext {
  TrackContext(
    super._participant, {
    required this.isScreenShare,
  });
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
