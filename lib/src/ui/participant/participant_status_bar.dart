import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../context/participant.dart';
import 'connection_quality_indicator.dart';
import 'e2e_encryption_indicator.dart';

class ParticipantStatusBar extends StatelessWidget {
  const ParticipantStatusBar({
    super.key,
    this.showName = true,
    this.showE2EEStatus = true,
    this.showConnectionQuality = true,
    this.showMuteStatus = true,
    this.isScreenShare = false,
  });

  final bool showName;
  final bool showE2EEStatus;
  final bool showConnectionQuality;
  final bool showMuteStatus;
  final bool isScreenShare;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantContext>(
      builder: (context, participantContext, child) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          color: Colors.black.withOpacity(0.6),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showMuteStatus)
                  Selector<ParticipantContext, bool>(
                    selector: (context, isMuted) => participantContext.isMuted,
                    builder: (context, isMuted, child) => isMuted
                        ? const Icon(
                            Icons.mic_off_sharp,
                            color: Colors.white54,
                            size: 20,
                          )
                        : const SizedBox(),
                  ),
                if (isScreenShare)
                  const Icon(
                    Icons.screen_share,
                    color: Colors.white54,
                    size: 20,
                  ),
                if (showName)
                  Selector<ParticipantContext, String?>(
                    selector: (context, name) => participantContext.name,
                    builder: (context, name, child) => name != null
                        ? Flexible(
                            child: Text(
                              isScreenShare ? '$name\'s screen' : name,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                  ),
                if (showConnectionQuality) const ConnectionQualityIndicator(),
                if (showE2EEStatus) const E2EEncryptionIndicator(),
              ]),
        ),
      ),
    );
  }
}
