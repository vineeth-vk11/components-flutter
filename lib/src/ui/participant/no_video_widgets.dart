import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../types/theme.dart';

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Icon(
          Icons.videocam_off_outlined,
          color: LKColors.lkBlue,
          size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
        ),
      ),
    );
  }
}
