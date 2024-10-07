import 'package:flutter/material.dart';

const primaryColor = Color(0xFFF16E00);
const secondaryColor = Color(0xFFFFB400);
const tertiaryColor = Color(0xFF7A40F2);
const bgColor = Color(0xFFF2FFFB);

const defaultPadding = 16.0;

class ErreurTaille extends StatelessWidget {
  const ErreurTaille({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            "Cette page n'est pas adaptée aux écrans de petite taille.",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
