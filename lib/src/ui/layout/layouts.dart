import 'package:flutter/widgets.dart';

import '../../types/track_identifier.dart';

class TrackWidget {
  TrackWidget(this.trackIdentifier, this.widget);
  final TrackIdentifier trackIdentifier;
  final Widget widget;
}

abstract class ParticipantLayoutBuilder {
  Widget build(
    BuildContext context,
    List<TrackWidget> children,
    List<String> pinnedTracks,
  );
}
