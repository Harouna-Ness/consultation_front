import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/screens/mobile/component/image_carousel.dart';
import 'package:medstory/screens/mobile/component/medecin_liste.dart';
import 'package:medstory/screens/mobile/component/partenaire_liste.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';
import 'package:medstory/screens/mobile/screen/medecin_liste_page.dart';
import 'package:medstory/screens/mobile/screen/partenaire_liste_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Medecinn> medecins = [
    Medecinn(
      nom: "Kanté",
      prenom: "Noumouden",
      specialite: "Cardiologie",
      imageAssetPath: "assets/images/medecinA.png", profileImage: null,
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinB.png", profileImage: null,
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinC.png", profileImage: null,
    ),
    Medecinn(
      nom: "Kanté",
      prenom: "Noumouden",
      specialite: "Cardiologie",
      imageAssetPath: "assets/images/medecinA.png", profileImage: null,
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinB.png", profileImage: null,
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinC.png", profileImage: null,
    ),
    // Ajoutez plus de médecins ici...
  ];

  final List<Partenaire> partenaire = [ //Mettre une condition: si parteListe.size > 4, ajouter que les 4 premiers.
    Partenaire(
      nom: "Kanté",
      prenom: "Noumouden",
      specialite: "Cardiologie",
      imageAssetPath: "assets/images/medecinA.png",
    ),
    Partenaire(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinB.png",
    ),
    Partenaire(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinC.png",
    ),
    Partenaire(
      nom: "Kanté",
      prenom: "Noumouden",
      specialite: "Cardiologie",
      imageAssetPath: "assets/images/medecinA.png",
    ),
    // Ajoutez plus de médecins ici...
  ];
  @override
  Widget build(BuildContext context) {
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
          MedecinListe(medecins: medecins, count: 3),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PartenaireListePage()));
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
          PartenaireListe(partenaires: partenaire, count: partenaire.length,)
        ],
      ),
    );
  }
}