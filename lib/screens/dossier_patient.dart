import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DossierPatient extends StatefulWidget {
  final Patient patient;
  final void Function() changeView;
  const DossierPatient(
      {super.key, required this.patient, required this.changeView});

  @override
  State<DossierPatient> createState() => _DossierPatientState();
}

class _DossierPatientState extends State<DossierPatient> {
  String token = '';

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString("auth_token");
    if (authToken != null) {
      token = authToken;
      print("token ::: $getToken");
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Box(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En tête
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dossier Patient",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showModal(
                      context: context,
                      data: widget.patient.dossierMedical!.fichiers!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tertiaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: const Icon(
                    Icons.attachment,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Fichiers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  // LOGIQUE POUR Fermer LE DOSSIER PATIENT
                  onPressed: widget.changeView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Fermer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // Information personnelle
            const SizedBox(
              height: defaultPadding,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Prénom",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.patient.prenom,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nom",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.patient.nom,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            // allergie
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Allergie",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (widget.patient.dossierMedical != null &&
                                widget
                                    .patient.dossierMedical!.allergies!.isEmpty)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 240, 239, 239),
                                      height: 100,
                                      child: const Center(
                                        child: Text(
                                          "Pas de contenu !",
                                          style: TextStyle(
                                            color: tertiaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: widget.patient.dossierMedical != null
                                    ? widget.patient.dossierMedical!.allergies!
                                        .map(
                                          (allergie) => Column(
                                            children: [
                                              Text(
                                                " - ${allergie.nom}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList()
                                    : [],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            // Les antecedents
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // antecedent
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Antecedent",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (widget.patient.dossierMedical != null &&
                                widget.patient.dossierMedical!.antecedents!
                                    .isEmpty)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 240, 239, 239),
                                      height: 100,
                                      child: const Center(
                                        child: Text(
                                          "Pas de contenu !",
                                          style: TextStyle(
                                            color: tertiaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: widget.patient.dossierMedical != null
                                    ? widget
                                        .patient.dossierMedical!.antecedents!
                                        .map(
                                          (antecedent) => Column(
                                            children: [
                                              Text(
                                                "- ${antecedent.nomMaladie}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList()
                                    : [],
                              ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: (widget.patient.dossierMedical != null &&
                            widget.patient.dossierMedical!.antecedents!.isEmpty)
                        ? 0
                        : 100,
                  ),
                  // antecedent familial
                  (widget.patient.dossierMedical != null &&
                          widget.patient.dossierMedical!.antecedentFamiliaux!
                              .isEmpty)
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Antecedent familial",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: widget.patient.dossierMedical != null
                                  ? widget.patient.dossierMedical!
                                      .antecedentFamiliaux!
                                      .map(
                                        (antecedent) => Column(
                                          children: [
                                            Text(
                                              "- ${antecedent.nomMaladie}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList()
                                  : [],
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            // consultation
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.patient.dossierMedical != null &&
                          widget.patient.dossierMedical!.consultations!.isEmpty)
                      ? const SizedBox()
                      : const Text(
                          "Consultation",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    // carte consultation design
                    children: widget.patient.dossierMedical != null
                        ? widget.patient.dossierMedical!.consultations!
                            .map(
                              (consultation) => Container(
                                height: 170,
                                width: 140,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[400]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Fait par",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Dr ${consultation.medecin!.nom}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const Spacer(),
                                    Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/Report.svg",
                                        height: 65,
                                        width: 70,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Le ${consultation.creationDate!.day}/${consultation.creationDate!.month}/${consultation.creationDate!.year}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                        : [],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal pour afficher toutes les données
  Future<void> _showModal({
    BuildContext? context,
    required List data,
  }) {
    return showDialog(
      context: context!,
      builder: (context) {
        return Dialog(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: Box(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8, // Largeur
                    child: data.isEmpty
                        ? const Center(
                            child: Text(
                              "Aucun fichier disponible !",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Column(
                            children: data.map((element) {
                              bool isImage = element.endsWith('.png') ||
                                  element.endsWith('.jpg') ||
                                  element.endsWith('.jpeg') ||
                                  element.endsWith('.gif');
                              return ListTile(
                                leading: isImage
                                    ? Image.network(
                                        headers: {
                                          'Authorization': 'Bearer $token'
                                        },
                                        "${DioClient.baseUrl}admin/dossier-medical/${widget.patient.dossierMedical!.id!}/download/$element",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.picture_as_pdf,
                                        size: 50, color: Colors.red),
                                title: Text(element),
                                trailing: IconButton(
                                  icon: const Icon(Icons.download),
                                  onPressed: () => _downloadFile(element),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _downloadFile(String fileName) async {
    try {
      final response = await DioClient.dio.download(
          "${DioClient.baseUrl}admin/dossier-medical/${widget.patient.dossierMedical!.id!}/download/$fileName",
          "/downloads/$fileName");

      if (response.statusCode == 200) {
        if (kIsWeb) {
          // Téléchargement en Web
          downloadFileWeb(response.data, fileName);
        } else {
          // Téléchargement en Desktop/Mobile
          final directory = await getApplicationDocumentsDirectory();
          final filePath = "${directory.path}/$fileName";
          final file = File(filePath);
          await file.writeAsBytes(response.data);

          OpenFilex.open(filePath);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du téléchargement")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du téléchargement")),
      );
    }
  }

  // Créer un URL temporaire
  void downloadFileWeb(Uint8List fileBytes, String fileName) {
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url); // Nettoyer l'URL temporaire
  }
}
