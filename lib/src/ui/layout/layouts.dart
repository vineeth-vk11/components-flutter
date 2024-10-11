import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import '../participant/track.dart';

abstract class ParticipantLayoutBuilder {
  Widget build(BuildContext context, Map<TrackContext, Widget> children);
}

class GridLayoutBuilder implements ParticipantLayoutBuilder {
  const GridLayoutBuilder();

  @override
  Widget build(BuildContext context, Map<TrackContext, Widget> children) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 1.5),
      children: children.values.toList(),
    );
  }
}

class CarouselLayoutBuilder implements ParticipantLayoutBuilder {
  const CarouselLayoutBuilder();

  @override
  Widget build(BuildContext context, Map<TrackContext, Widget> children) {
    return Row(
      children: [
        if (children.length > 1)
          SizedBox(
            width: 180,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: math.max(0, children.length - 1),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 180,
                  height: 120,
                  child: children.values.toList()[index + 1],
                ),
              ),
            ),
          ),
        Expanded(
            child: children.isNotEmpty ? children.values.first : Container()),
      ],
    );
  }
}

class FocusLayout implements ParticipantLayoutBuilder {
  const FocusLayout();

  @override
  Widget build(BuildContext context, Map<TrackContext, Widget> children) {
    return Stack(
      children: children.values.toList(),
    );
  }
}
