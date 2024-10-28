import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              color: const Color.fromARGB(255, 240, 239, 239),
              height: 200,
              child: const Center(
                child: Text(
                  "Pas de contenu !",
                  style: TextStyle(
                    color: tertiaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }
}