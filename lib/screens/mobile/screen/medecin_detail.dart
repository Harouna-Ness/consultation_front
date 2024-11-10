import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/dossier_medical.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/screens/mobile/component/rdv_dialog.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:provider/provider.dart';

class MedecinDetail extends StatelessWidget {
  final Medecin medecin;
  const MedecinDetail({super.key, required this.medecin});

  @override
  Widget build(BuildContext context) {
    Utilisateur user = context.watch<MyData>().currentUser!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            CircleAvatar(
              backgroundColor: Colors.black.withOpacity(.2),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey,
            height: size.height,
          ),
          medecin.profileImage != null
              ? Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    color: const Color.fromARGB(255, 101, 83, 116),
                    height: size.height * 0.56,
                    child: Image.network(
                      "${DioClient.baseUrl}profile-images/${medecin.profileImage!}",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.grey[200],
                    height: size.height * 0.56,
                    child: const Center(
                      child: Icon(
                        Icons.person_outlined,
                        color: Colors.grey,
                        size: 150,
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * .45,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${medecin.prenom} ${medecin.nom}",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                    ),
                    Text(
                      medecin.specialite,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Disponibilité",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: medecin.joursIntervention.map((jour) {
                          return DisoBox(
                            jour: jour['jour'],
                            heureDebut: jour['heureDebut'],
                            heureFin: jour['heureFin'],
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Afficher le BottomSheet lorsque le bouton est cliqué
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled:
                                    true, // Permet de contrôler la hauteur du BottomSheet
                                builder: (BuildContext context) {
                                  return RdvDialog(
                                    medecin: medecin,
                                    patient: Patient(
                                        id: user.id,
                                        nom: "nom",
                                        prenom: "prenom",
                                        role: Role(id: 0, libelle: "libelle"),
                                        adresse: "adresse",
                                        email: "email",
                                        telephone: "telephone",
                                        motDePasse: "motDePasse",
                                        sexe: "sexe",
                                        dateDeNaissance: DateTime.now(),
                                        proffession: "proffession",
                                        sitedetravail:
                                            Sitedetravail(id: 0, nom: "nom"),
                                        direction: Direction(id: 0, nom: "nom"),
                                        dossierMedical: DossierMedical(),
                                        statut: StatutPatient(
                                            id: 0, libelle: "libelle"),
                                        profileImage: null),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Prendre Rendez-vous',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisoBox extends StatelessWidget {
  final String? jour;
  final String? heureDebut;
  final String? heureFin;

  const DisoBox({super.key, this.jour, this.heureDebut, this.heureFin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 70,
        width: 65,
        decoration: const BoxDecoration(
          color: tertiaryColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              jour != null
                  ? jour!.substring(0, 3)
                  : '', // Affiche les 3 premières lettres du jour
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${heureDebut!.substring(0, 2)}h - ${heureFin!.substring(0, 2)}h', // Format d'affichage des heures
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
