import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateChip extends StatelessWidget {
  final DateTime date;
  final Color color;

  String getText() {
    return '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
  }

  const CustomDateChip({
    Key? key,
    required this.date,
    this.color = const Color(0x558AD3D5),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
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
    );
  }
}
