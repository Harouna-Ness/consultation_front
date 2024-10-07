import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class Indicateur extends StatelessWidget {
  const Indicateur({
    super.key,
    required this.label,
    required this.indice,
    required this.barSeek,
  });

  final String label;
  final int indice;
  final double barSeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                color: primaryColor,
                minHeight: 12,
                borderRadius: BorderRadius.circular(20),
                value: barSeek,
              ),
            ),
            const SizedBox(
              width: defaultPadding * 3,
            ),
            Text(
              indice.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}