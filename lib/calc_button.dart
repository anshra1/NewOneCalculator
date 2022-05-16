import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({required this.onTap, required this.text, required this.buttonColor});

  VoidCallback onTap;
  String text;
  Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(60))),

        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
