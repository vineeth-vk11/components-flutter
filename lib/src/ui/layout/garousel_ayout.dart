import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'layouts.dart';

class CarouselLayoutBuilder implements ParticipantLayoutBuilder {
  const CarouselLayoutBuilder();

  @override
  Widget build(
      BuildContext context, List<Widget> children, List<Widget>? pinned) {
    Widget? pinnedWidget;
    List<Widget> otherWidgets = [];

    if (pinned != null) {
      pinnedWidget = pinned.firstOrNull;
      if (children.length > 1) {
        otherWidgets = pinned.skip(1).toList();
        otherWidgets.addAll(children);
      }
    } else {
      pinnedWidget = children.firstOrNull;
      if (children.length > 1) {
        otherWidgets = children.skip(1).toList();
      }
    }

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
                itemCount: math.max(0, otherWidgets.length),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 120,
                  height: 80,
                  child: otherWidgets[index],
                ),
              ),
            ),
          Expanded(
            child: pinnedWidget ?? Container(),
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
              itemCount: math.max(0, otherWidgets.length),
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: 180,
                height: 120,
                child: otherWidgets[index],
              ),
            ),
          ),
        Expanded(
          child: pinnedWidget ?? Container(),
        ),
      ],
    );
  }
}
