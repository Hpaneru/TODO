import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttontext;

  Button(
    {
      @required this.onPressed,
      @required this.buttontext,
    }
  );
  @override
  Widget build(BuildContext edit) {
    return MaterialButton(
      onPressed: onPressed, 
      child: Text(buttontext),
    );
  }
}