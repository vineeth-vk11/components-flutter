import 'package:flutter/widgets.dart';

class ParticipantIdentity {
  const ParticipantIdentity({
    required this.identity,
    this.sid,
  });

  final String identity;
  final String? sid;
}

abstract class ParticipantLayoutBuilder {
  Widget build(
      BuildContext context, List<Widget> children, List<Widget>? pinned);
}
