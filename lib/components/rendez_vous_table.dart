import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class RendezVousTable extends StatefulWidget {
  final List<RendezVous> rendezVousList;

  const RendezVousTable({super.key, required this.rendezVousList});

  @override
  State<RendezVousTable> createState() => _RendezVousTableState();
}

class _RendezVousTableState extends State<RendezVousTable> {
  final rendezVousService = RendezVousService();
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
              'Médecin',
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
                  rendezVous.statut.libelle.contains("confirmé")
                      ? const Icon(Icons.check, color: Colors.grey)
                      : IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            // Action pour accepter le rendez-vous
                            context.showLoader();

                            await rendezVousService.changeRendezVousStatut(
                                rendezVous.id,
                                {"id": 3, "libelle": "confirmé"}).then((value) {
                              context.read<MyData>().fetchRendezVous();
                              context.hideLoader();
                              context.showSuccess(
                                  "Le rendez-vous a été confirmé avec succès.");
                            }).catchError((onError) {
                              context.hideLoader();
                              context.showError("Oups !");
                            });
                          },
                        ),
                  rendezVous.statut.libelle.contains("annulé")
                      ? const Icon(Icons.cancel, color: Colors.grey)
                      : IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.orange),
                          onPressed: () async {
                            // Action pour annuler le rendez-vous
                            context.showLoader();

                            await rendezVousService.changeRendezVousStatut(
                                rendezVous.id,
                                {"id": 2, "libelle": "annulé"}).then((value) {
                              context.read<MyData>().fetchRendezVous();
                              context.hideLoader();
                              context.showSuccess(
                                  "Le rendez-vous a été annulé avec succès.");
                            }).catchError((onError) {
                              context.hideLoader();
                              context.showError("Oups !");
                            });
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
                  '${rendezVous.medecin.prenom} ${rendezVous.medecin.nom}')),
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
