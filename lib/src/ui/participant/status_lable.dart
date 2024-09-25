import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant.dart';
import 'e2e_encryption_indicator.dart';

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
                const E2EEncryptionIndicator(),
                Selector<ParticipantContext, bool>(
                  selector: (context, isMuted) => participantContext.isMuted,
                  builder: (context, isMuted, child) => isMuted
                      ? const Flexible(
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white54,
                          ),
                        )
                      : const SizedBox(),
                ),
                Selector<ParticipantContext, String?>(
                  selector: (context, name) => participantContext.name,
                  builder: (context, name, child) => name != null
                      ? Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                            overflow: TextOverflow.ellipsis,
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
