import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/rdv_reprog.dart';
import 'package:medstory/components/time_slot_selector.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
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
  String? heureRdv;
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
                              context.showError(onError.toString());
                            });
                          },
                        ),
                  rendezVous.statut.libelle.contains("annulé")
                      ? const Icon(Icons.cancel, color: Colors.grey)
                      : IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.orange,
                          ),
                          onPressed: () async {
                            customRdvModal(
                              context,
                              rendezVous,
                            );
                          },
                        ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {
                      context.showConfirmation(
                          title: "Attention !!",
                          message:
                              "Cette action supprime le rendez-vous.\nÊtes-vous sûr(e) de continuer ?",
                          onConfirm: () async {
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
                          });
                    },
                  ),
                ],
              )),
              DataCell(Text(
                  '${rendezVous.patient.prenom} ${rendezVous.patient.nom}')),
              DataCell(Text(
                  '${rendezVous.medecin.prenom} ${rendezVous.medecin.nom}')),
              DataCell(
                Text(
                  DateFormat('dd-MM-yyyy').format(rendezVous.date),
                ),
              ),
              DataCell(Text(rendezVous.heure)),
              DataCell(Text(rendezVous.motif)),
              DataCell(Text(rendezVous.statut.libelle)),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Future<dynamic> customRdvModal(BuildContext contexte, RendezVous rdv) {
    return showDialog(
        context: contexte,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: FractionallySizedBox(
              heightFactor: 0.85,
              widthFactor: 0.8,
              child: RdvReprog(
                rdv: rdv,
              ),
            ),
          );
        });
  }
}
