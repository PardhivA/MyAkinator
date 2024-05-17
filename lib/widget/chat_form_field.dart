import 'package:flutter/material.dart';

class ChatFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isReadOnly;
  final void Function(String)? onFieldSubmitted;

  const ChatFormField(
      {super.key,
      this.focusNode,
      this.controller,
      this.isReadOnly = false,
      required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // scrollPadding: const EdgeInsets.only(bottom: 50),
      controller: controller,
      autofocus: true,
      autocorrect: false,
      focusNode: focusNode,
      readOnly: isReadOnly,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: "Enter your Answer",
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ))),
      validator: (value) {
        if (value == null) {
          return 'Please enter some answer';
        }
        return null;
      },
    );
  }
}
