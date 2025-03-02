import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/doctor_edit_form.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/mobile/screen/medecin_detail.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/service/medecin_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class DoctorTable extends StatefulWidget {
  final List<Medecin> medecinList;
  const DoctorTable({super.key, required this.medecinList});

  @override
  State<DoctorTable> createState() => _DoctorTableState();
}

class _DoctorTableState extends State<DoctorTable> {
  // Traduire les jours en français
  String dayInFrench(String day) {
    String jour = '';
    switch (day) {
      case "MONDAY":
        jour = 'Lundi';
        break;
      case "TUESDAY":
        jour = 'Mardi';
        break;
      case "WEDNESDAY":
        jour = 'Mercredi';
        break;
      case "THURSDAY":
        jour = 'Jeudi';
        break;
      case "FRIDAY":
        jour = 'Vendredi';
        break;
      case "SATURDAY":
        jour = 'Samedi';
        break;
      default:
        jour = 'Dimanche';
    }
    return jour;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(
                label: Text(
              'Nom',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Prénom',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Matricule',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Téléphone',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Spécialité',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
          rows: widget.medecinList.map((medecin) {
            return DataRow(cells: [
              DataCell(SizedBox(width: 100, child: Text(medecin.prenom))),
              DataCell(SizedBox(width: 100, child: Text(medecin.nom))),
              DataCell(Text(medecin.matricule)),
              DataCell(SizedBox(width: 100, child: Text(medecin.telephone))),
              DataCell(Text(medecin.specialite)),
              DataCell(Row(
                children: [
                  // Bouton pour modifier
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {
                      // Action pour modifier le médecin
                      editeModal(context, medecin);
                    },
                  ),
                  // Bouton pour voir les details du medecin
                  IconButton(
                    icon: SvgPicture.asset(
                      color: tertiaryColor,
                      "assets/icons/menu_doc.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {
                      // Action pour afficher les details du médecin
                      detailModal(context, medecin);
                    },
                  ),
                  // Bouton pour supprimer le medecin
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {
                      context.showConfirmation(
                        title: "Suppression",
                        message:
                            "Êtes-vous sûr de vouloir supprimer cet élément ?",
                        onConfirm: () async {
                          // Action pour supprimer le médecin
                          context.showLoader();
                          final medecinService = MedecinService();
                          await medecinService
                              .deleteMedecin(medecin.id!)
                              .then((value) {
                            context.read<MyData>().fetchMedecins();
                            context.hideLoader();
                          }).catchError((onError) {
                            context.showError(onError.toString());
                          }).whenComplete(() {
                            context.showSuccess(
                                "Le médecin a été supprimé avec succès.");
                          });
                        },
                      );
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Future<dynamic> editeModal(BuildContext context, Medecin med) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: DoctorEditForm(medecin: med),
          ),
        );
      },
    );
  }

  Future<dynamic> detailModal(BuildContext context, Medecin med) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.9,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 101, 83, 116),
                            height: 200,
                            width: 200,
                            child: Image.network(
                              "${DioClient.baseUrl}profile-images/${med.profileImage!}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "${med.prenom} ${med.nom}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                          Text(
                            med.specialite,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "téléphone: ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            med.telephone,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Adresse: ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            med.adresse ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Matricule: ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            med.matricule,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Disponibilité",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
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
                              children: med.joursIntervention.map((jour) {
                                return DisoBox(
                                  jour: dayInFrench(jour['jour']),
                                  heureDebut: jour['heureDebut'],
                                  heureFin: jour['heureFin'],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
