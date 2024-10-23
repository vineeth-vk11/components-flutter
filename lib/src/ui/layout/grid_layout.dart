import 'package:flutter/widgets.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'layouts.dart';

class GridLayoutBuilder implements ParticipantLayoutBuilder {
  const GridLayoutBuilder();

  @override
  Widget build(BuildContext context, List<Widget> children) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    return GridView.count(
      crossAxisCount: deviceScreenType == DeviceScreenType.mobile ? 2 : 4,
      childAspectRatio: 1.5,
      children: children,
    );
  }
}
