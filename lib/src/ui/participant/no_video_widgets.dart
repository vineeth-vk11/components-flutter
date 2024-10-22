import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../types/theme.dart';
import '../debug/logger.dart';

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({
    super.key,
    required this.sid,
  });

  final String? sid;

  @override
  Widget build(BuildContext context) {
    Debug.log('===>     NoVideoWidget for $sid');
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
