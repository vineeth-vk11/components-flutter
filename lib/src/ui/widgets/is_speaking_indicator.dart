import 'package:flutter/material.dart';

import 'theme.dart';

class IsSpeakingIndicatorWidget extends StatelessWidget {
  const IsSpeakingIndicatorWidget({
    Key? key,
    required this.isSpeaking,
    required this.child,
  }) : super(key: key);

  final bool isSpeaking;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        border: isSpeaking
            ? Border.all(
                width: 3,
                color: LKColors.lkBlue,
              )
            : null,
      ),
      child: child,
    );
  }
}
