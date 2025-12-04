import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/rdv_reprog.dart';
import 'package:medstory/models/medecin.dart';
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
  final rendezVousService = RendezVousService();
  Medecin? medecin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MyData>()
          .fetchRendezVousmedecin(context.watch<MyData>().currentMedecin!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    medecin = context
        .watch<MyData>()
        .currentMedecin!; //TODO: s'assurer d'avoir le bon
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
                              context
                                  .read<MyData>()
                                  .fetchRendezVousmedecin(medecin!.id!);
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
                            customRdvModal(
                              context,
                              rendezVous,
                            ).whenComplete(() {
                              context
                                  .read<MyData>()
                                  .fetchRendezVousmedecin(medecin!.id!);
                            });

                            // context.showLoader();

                            // await rendezVousService.changeRendezVousStatut(
                            //     rendezVous.id,
                            //     {"id": 2, "libelle": "annulé"}).then((value) {
                            //   context
                            //       .read<MyData>()
                            //       .fetchRendezVousmedecin(medecin!.id!);
                            //   context.hideLoader();
                            //   context.showSuccess(
                            //       "Le rendez-vous a été annulé avec succès.");
                            // }).catchError((onError) {
                            //   context.hideLoader();
                            //   context.showError("Oups !");
                            // });
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
                      context.showConfirmation(
                        title: "Attention !!",
                        message:
                            "Cette action supprime le rendez-vous.\nÊtes-vous sûr(e) de continuer ?",
                        onConfirm: () async {
                          context.showLoader();
                          final rendezVousService = RendezVousService();
                          await rendezVousService
                              .deleteRendezVous(rendezVous.id)
                              .then((value) {
                            context.read<MyData>().fetchRendezVousmedecin(medecin!
                                .id!); //TODO: Remplacer la logique (fetch only for current user)
                            context.hideLoader();
                            context.showSuccess(
                                "Le rendez-vous a été supprimé avec succès.");
                          }).catchError((onError) {
                            context.hideLoader();
                            context.showError(onError.toString());
                          });
                        },
                      );
                    },
                  ),
                ],
              )),
              DataCell(SizedBox(
                width: 200,
                child: Text(
                    '${rendezVous.patient.prenom} ${rendezVous.patient.nom}'),
              )),
              DataCell(SizedBox(
                width: 100,
                child: Text(
                    '${rendezVous.date.day}/${rendezVous.date.month}/${rendezVous.date.year}'),
              )),
              DataCell(SizedBox(width: 100, child: Text(rendezVous.heure))),
              DataCell(SizedBox(width: 100, child: Text(rendezVous.motif))),
              DataCell(
                  SizedBox(width: 100, child: Text(rendezVous.statut.libelle))),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Future<dynamic> customRdvModal(BuildContext contexte, RendezVous rdv) {
    return showDialog(
        context: contexte,
        builder: (contexte) {
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
