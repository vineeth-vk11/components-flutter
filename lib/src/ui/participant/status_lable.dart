import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/participant.dart';

class StatusLable extends StatelessWidget {
  const StatusLable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) => SizedBox(
        width: 160,
        height: 28,
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Selector<ParticipantContext, bool>(
                  selector: (context, isMuted) => participantContext.isMuted,
                  builder: (context, isMuted, child) => isMuted
                      ? const Flexible(
                          child: Icon(Icons.mic_off),
                        )
                      : const SizedBox(),
                ),
                Selector<ParticipantContext, String?>(
                  selector: (context, name) => participantContext.name,
                  builder: (context, name, child) => name != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Flexible(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : Container(),
                )
              ]),
        ),
      ),
    );
  }
}
