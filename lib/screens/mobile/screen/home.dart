import 'package:flutter/material.dart';
import 'package:medstory/components/add_user_form.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/partenaire.dart';
import 'package:medstory/screens/mobile/component/image_carousel.dart';
import 'package:medstory/screens/mobile/component/medecin_liste.dart';
import 'package:medstory/screens/mobile/component/partenaire_liste.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';
import 'package:medstory/screens/mobile/screen/medecin_liste_page.dart';
import 'package:medstory/screens/mobile/screen/partenaire_liste_page.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Medecin> medecins = [
  ];

  List<Partenaire> partenaire = [
  ];
  @override
  Widget build(BuildContext context) {
    medecins = context.watch<MyData>().medecins.take(3).toList();
    partenaire = context.watch<MyData>().partenaires.take(4).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const ImageCarousel(
            images: [
              "assets/images/medecinA.png",
              "assets/images/medecinpub.png",
            ],
          ),
          // Médecin section ------------------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nos Médecins"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MedecinListPage()));
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(
                    color: tertiaryColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          MedecinListe(medecins: medecins, count: medecins.length),
          const SizedBox(
            height: 10,
          ),
          // Partenaires section ------------------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nos partenaires"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const PartenaireListePage()));
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(
                    color: tertiaryColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          PartenaireListe(
            partenaires: partenaire,
            count: partenaire.length,
          ),
        ],
      ),
    );
  }
}
