import 'package:flutter/material.dart';
class CollapsedButton {
  const CollapsedButton(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed});

  final Icon icon;
  final Widget title;
  final VoidCallback onPressed;
}
