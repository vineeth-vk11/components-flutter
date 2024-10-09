import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {super.key,
      required this.onTextChanged,
      required this.hintText,
      String? text})
      : _textController = TextEditingController(text: text ?? '');

  final TextEditingController _textController;

  final Function(String) onTextChanged;

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      minLines: 1,
      maxLines: 1,
      onChanged: onTextChanged,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintMaxLines: 1,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 0.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.black26,
            width: 0.2,
          ),
        ),
      ),
    );
  }
}
