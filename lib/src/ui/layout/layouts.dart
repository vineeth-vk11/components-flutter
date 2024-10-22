import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:math' as math;

abstract class ParticipantLayoutBuilder {
  Widget build(BuildContext context, List<Widget> children);
}

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

class CarouselLayoutBuilder implements ParticipantLayoutBuilder {
  const CarouselLayoutBuilder();

  @override
  Widget build(BuildContext context, List<Widget> children) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    if (deviceScreenType == DeviceScreenType.mobile) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (children.length > 1)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: math.max(0, children.length - 1),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 120,
                  height: 80,
                  child: children[index + 1],
                ),
              ),
            ),
          Expanded(
            child: children.isNotEmpty ? children.first : Container(),
          ),
        ],
      );
    }
    return Row(
      children: [
        if (children.length > 1)
          SizedBox(
            width: 180,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: math.max(0, children.length - 1),
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: 180,
                height: 120,
                child: children[index + 1],
              ),
            ),
          ),
        Expanded(
          child: children.isNotEmpty ? children.first : Container(),
        ),
      ],
    );
  }
}

class FocusLayout implements ParticipantLayoutBuilder {
  const FocusLayout();

  @override
  Widget build(BuildContext context, List<Widget> children) {
    return Stack(
      children: children,
    );
  }
}
