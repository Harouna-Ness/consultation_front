import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Box extends StatelessWidget {
  Box({super.key, required this.child, this.padding = 16});
  final Widget child;
  double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding!),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: .1,
            spreadRadius: .1,
            offset: Offset(0, 1),
            blurStyle: BlurStyle.outer,
            color: Colors.grey,
          ),
        ],
      ),
      child: child,
    );
  }
}
