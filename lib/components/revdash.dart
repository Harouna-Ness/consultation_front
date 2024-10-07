import 'package:flutter/material.dart';
import 'package:medstory/components/indicateur.dart';
import 'package:medstory/constantes.dart';

class RdvDash extends StatelessWidget {
  const RdvDash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rendez-vous",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          height: size.width < 300 ? 5 : defaultPadding,
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Indicateur(
                label: "Confirmé",
                indice: 9,
                barSeek: .7,
              ),
              Indicateur(
                label: "En attente",
                indice: 6,
                barSeek: .5,
              ),
              Indicateur(
                label: "Annulé",
                indice: 0,
                barSeek: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
