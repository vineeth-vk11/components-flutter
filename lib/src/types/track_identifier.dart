import 'package:livekit_client/livekit_client.dart';

class TrackIdentifier {
  TrackIdentifier(this.participant, [this.track]);
  final Participant participant;
  final TrackPublication? track;

  String? get identifier => track?.sid ?? participant.sid;
}
