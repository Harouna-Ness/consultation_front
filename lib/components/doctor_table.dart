import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/doctor_edit_form.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
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
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () async {
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
}
