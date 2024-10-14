import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CustomDateNameChip extends StatelessWidget {
  final DateTime date;
  final Color color;
  final String? name;

  String getText() {
    return '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
  }

  const CustomDateNameChip({
    Key? key,
    required this.date,
    this.name,
    this.color = const Color(0x558AD3D5),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (name != null)
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
            ),
            child: Text(
              name!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8AD3D5),
              ),
            ),
          ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 7,
                bottom: 7,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  color: color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    getText(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
