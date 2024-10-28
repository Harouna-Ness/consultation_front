import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class RdvTabMedPortail extends StatefulWidget {
  final List<RendezVous> rendezVousList;

  const RdvTabMedPortail({super.key, required this.rendezVousList});

  @override
  State<RdvTabMedPortail> createState() => _RdvTabMedPortailState();
}

class _RdvTabMedPortailState extends State<RdvTabMedPortail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(
                label: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Patient',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Heure',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Motif',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Statut',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
          rows: widget.rendezVousList.map((rendezVous) {
            return DataRow(cells: [
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      // Action pour accepter le rendez-vous
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.orange),
                    onPressed: () {
                      // Action pour annuler le rendez-vous
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () async {
                      // Action pour supprimer le médecin
                      context.showLoader();
                      final rendezVousService = RendezVousService();
                      await rendezVousService
                          .deleteRendezVous(rendezVous.id)
                          .then((value) {
                        context
                            .read<MyData>()
                            .fetchRendezVous(); //TODO: Remplacer la logique (fetch only for current user)
                        context.hideLoader();
                        context.showSuccess(
                            "Le rendez-vous a été supprimé avec succès.");
                      }).catchError((onError) {
                        context.hideLoader();
                        context.showError(onError.toString());
                      });
                    },
                  ),
                ],
              )),
              DataCell(Text(
                  '${rendezVous.patient.prenom} ${rendezVous.patient.nom}')),
              DataCell(Text(
                  '${rendezVous.date.day}/${rendezVous.date.month}/${rendezVous.date.year}')),
              DataCell(Text(rendezVous.heure)),
              DataCell(Text(rendezVous.motif)),
              DataCell(Text(rendezVous.statut.libelle)),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}
