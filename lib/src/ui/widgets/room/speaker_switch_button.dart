import 'package:flutter/material.dart';

class SpeakerSwitchButton extends StatelessWidget {
  const SpeakerSwitchButton({
    super.key,
    this.isSpeakerOn = false,
    this.onToggle,
    this.disabled = false,
  });

  final bool isSpeakerOn;
  final Function(bool speakerOn)? onToggle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.9)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStateProperty.all(Colors.grey),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)))),
        padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
      ),
      onPressed: () => onToggle?.call(!isSpeakerOn),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSpeakerOn ? Icons.speaker_phone : Icons.phone_android),
        ],
      ),
    );
  }
}
