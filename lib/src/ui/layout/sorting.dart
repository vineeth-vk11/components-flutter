import 'package:livekit_client/livekit_client.dart';

import 'layouts.dart';

List<TrackWidget> defaultSorting(List<TrackWidget> trackWidgets) {
  List<TrackWidget> trackWidgetsSorted = [];

  /// sort screen shares and local participant first
  for (var element in trackWidgets) {
    if (element.trackIdentifier.track?.isScreenShare == true ||
        element.trackIdentifier.participant is LocalParticipant) {
      trackWidgetsSorted.insert(0, element);
    } else {
      trackWidgetsSorted.add(element);
    }
  }

  // sort speakers for the grid
  trackWidgetsSorted.sort((a, b) {
    // loudest speaker first
    var participantA = a.trackIdentifier.participant;
    var participantB = b.trackIdentifier.participant;
    if (participantA.isSpeaking && participantB.isSpeaking) {
      if (participantA.audioLevel > participantB.audioLevel) {
        return -1;
      } else {
        return 1;
      }
    }

    // last spoken at
    final aSpokeAt = participantA.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
    final bSpokeAt = participantB.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

    if (aSpokeAt != bSpokeAt) {
      return aSpokeAt > bSpokeAt ? -1 : 1;
    }

    // video on
    if (participantA.hasVideo != participantB.hasVideo) {
      return participantA.hasVideo ? -1 : 1;
    }

    // joinedAt
    return participantA.joinedAt.millisecondsSinceEpoch -
        participantB.joinedAt.millisecondsSinceEpoch;
  });

  return trackWidgetsSorted;
}
