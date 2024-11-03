import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/screens/mobile/component/medecin_liste.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';

class MedecinListPage extends StatelessWidget {
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
      imageAssetPath: "assets/images/medecinC.png",profileImage: null,
    ),
    // Ajoutez plus de médecins ici...
  ];

  MedecinListPage({super.key});

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
      body: MedecinListe(
        medecins: medecins,
        count: medecins.length,
      ),
    );
  }
}
