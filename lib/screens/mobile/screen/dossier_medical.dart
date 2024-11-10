import 'package:flutter/material.dart';
import 'package:medstory/components/customTable.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/service/pdf_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class DossierMedicalPage extends StatefulWidget {
  const DossierMedicalPage({super.key});

  @override
  State<DossierMedicalPage> createState() => _DossierMedicalPageState();
}

class _DossierMedicalPageState extends State<DossierMedicalPage> {
  Patient? _patient;
  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Date non disponible';
    }
    return 'Le ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    // _getPatient(); // Remplacer 1 par l'ID du patient à récupérer
  }

  Future<void> _getPatient() async {
    final patientService = PatientService();
    try {
      _patient = await patientService
          .getPatient(context.watch<MyData>().currentUser!.id!);
      setState(() {});
    } catch (e) {
      // Gérer l'erreur de manière appropriée
      print('Erreur lors de la récupération du patient : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _patient = context.watch<MyData>().currentPatient;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _patient != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Informations personnelles', [
                    'Nom: ${_patient!.nom}',
                    'Prénom: ${_patient!.prenom}',
                    'Date de naissance: le ${_patient!.dateDeNaissance!.day.toString().padLeft(2, '0')}/${_patient!.dateDeNaissance!.month.toString().padLeft(2, '0')}/${_patient!.dateDeNaissance!.year.toString().padLeft(2, '0')}',
                    'Sexe: ${_patient!.sexe}',
                    'Téléphone: ${_patient!.telephone}',
                    'Statut: ${_patient!.statut!.libelle}',
                    'Matricule: ${_patient!.id}',
                  ]),
                  const SizedBox(height: 16.0),
                  _buildInfoSection(
                    'Antécédents',
                    _patient!.dossierMedical?.antecedents!
                            .map((toElement) =>
                                'Nom de la maladie 1: ${toElement.nomMaladie}')
                            .toList() ??
                        ['Nom de la maladie : -'],
                  ),
                  const SizedBox(height: 16.0),
                  _buildInfoSection(
                      'Familiaux',
                      _patient!.dossierMedical?.antecedentFamiliaux!
                              .map((toElement) =>
                                  'Nom de la maladie 1: ${toElement.nomMaladie}')
                              .toList() ??
                          ['Nom de la maladie : -']),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Mes consultations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color.fromARGB(255, 235, 214, 250),
                      thickness: 1, // Épaisseur du divider
                      indent: 40, // Décalage depuis la gauche
                      endIndent: 40, // Décalage depuis la droite
                    ),
                    itemCount: _patient!.dossierMedical!.consultations!.length,
                    itemBuilder: (context, index) {
                      Consultation consultation =
                          _patient!.dossierMedical!.consultations![index];
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // Permet de contrôler la hauteur du BottomSheet
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Médecin: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  consultation.medecin!.nom,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Date: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  formatDate(consultation
                                                      .creationDate),
                                                  // '${consultation.creationDate!.day.toString().padLeft(2, '0')}/${consultation.creationDate!.month.toString().padLeft(2, '0')}/${consultation.creationDate!.year.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ExpansionTile(
                                              title: const Text(
                                                "Symptômes et Diagnostic",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              children: [
                                                consultation.symptome != null
                                                    ? ListTile(
                                                        title: const Text(
                                                          "Symptômes",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          consultation
                                                              .symptome!,
                                                        ),
                                                      )
                                                    : const Text(
                                                        "pas de symptôme",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                consultation.diagnostic != null
                                                    ? ListTile(
                                                        title: const Text(
                                                          "Diagnostic",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          consultation
                                                              .diagnostic!,
                                                        ),
                                                      )
                                                    : const Text(
                                                        "pas de diagnostic",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            ExpansionTile(
                                              title: const Text(
                                                "Analyses",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              children: [
                                                if (consultation.bilan !=
                                                        null &&
                                                    consultation
                                                            .bilan!.analyses !=
                                                        null &&
                                                    consultation.bilan!
                                                        .analyses!.isNotEmpty)
                                                  ...consultation
                                                      .bilan!.analyses!
                                                      .map((analysis) =>
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4.0),
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              analysis.libelle!,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList()
                                                else
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            ExpansionTile(
                                              title: const Text(
                                                "Prescription",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              children: [
                                                if (consultation
                                                    .prescriptions!.isNotEmpty)
                                                  ...consultation.prescriptions!
                                                      .map(
                                                          (analysis) => Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4.0),
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  analysis,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList()
                                                else
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              context.showLoader();
                                              final pdfService = PdfService();
                                              await pdfService
                                                  .generatePdf(consultation)
                                                  .then((onValue) {
                                                context.showSuccess(
                                                    "Téléchargé !");
                                                context.hideLoader();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              backgroundColor: tertiaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: const Text(
                                              'Télécharger',
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: const Text(
                                              'Fermer',
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
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fais par Dr ${consultation.medecin!.nom}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              formatDate(consultation.creationDate),
                              // 'Le {consultation.creationDate!.day.toString().padLeft(2, '0')}/{consultation.creationDate!.month.toString().padLeft(2, '0')}/{consultation.creationDate!.year.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 8.0),
        ...items.map((item) => Text(item)).toList(),
      ],
    );
  }
}
