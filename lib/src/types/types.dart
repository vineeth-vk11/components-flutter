import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> fToastNavigatorKey = GlobalKey<NavigatorState>();

class WatchValue<T,S> {
  WatchValue(this.value);

  T value;
}

/*
class Selector<ParticipantContext, List<VideoTrack>>(
        selector: (context, tracks) => participantContext.videoTracks,
        builder: (context, tracks, child)*/