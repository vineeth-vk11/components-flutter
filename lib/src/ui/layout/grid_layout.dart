import 'package:flutter/widgets.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'layouts.dart';

class GridLayoutBuilder implements ParticipantLayoutBuilder {
  const GridLayoutBuilder();

  @override
  Widget build(
    BuildContext context,
    List<TrackWidget> children,
    List<String> pinnedTracks,
  ) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    var orientation = MediaQuery.of(context).orientation;
    return GridView.count(
      crossAxisCount: deviceScreenType == DeviceScreenType.mobile &&
              orientation == Orientation.portrait
          ? 2
          : 4,
      childAspectRatio: 1.5,
      children: children.map((e) => e.widget).toList(),
    );
  }
}
