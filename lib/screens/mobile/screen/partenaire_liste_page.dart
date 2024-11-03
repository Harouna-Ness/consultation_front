import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/screens/mobile/component/categorie_liste.dart';
import 'package:medstory/screens/mobile/component/partenaire_liste.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';

class PartenaireListePage extends StatefulWidget {
  const PartenaireListePage({super.key});

  @override
  State<PartenaireListePage> createState() => _PartenaireListePageState();
}

class _PartenaireListePageState extends State<PartenaireListePage> {
  final List<Partenaire> partenaire = [
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset("assets/icons/MedStory.svg"),
        actions: [
          InkWell(
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: SvgPicture.asset(
                "assets/icons/Notification.svg",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CategorieListe(categories: [],),
            const SizedBox(
              height: 10,
            ),
            PartenaireListe(
              partenaires: partenaire,
              count: partenaire.length,
            ),
          ],
        ),
      ),
    );
  }
}
