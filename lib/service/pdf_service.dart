import 'dart:io';
import 'package:flutter/services.dart';
import 'package:medstory/models/consultation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> generatePdf(Consultation consultation) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Consultation ID: ${consultation.id}',
                  style: const pw.TextStyle(fontSize: 20)),
              // pw.Text('Diagnostic: ${consultation.diagnostic}'),
              pw.Text('Symptômes: ${consultation.symptome}'),
              pw.Text('Date de Création: ${consultation.creationDate}'),
              pw.Text('Médecin: ${consultation.medecin?.nom}'),
              pw.Text(
                  'Type de Consultation: ${consultation.typeDeConsultation?.libelle}'),
            ],
          );
        },
      ),
    );

    // Le chemin pour sauvegarder le PDF
    final directory = await getExternalStorageDirectory();
    final downloadPath = '${directory!.path}/Download';
    final file = File('$downloadPath/consultation_${consultation.id}.pdf');

    // Créez le dossier s'il n'existe pas
    if (!await Directory(downloadPath).exists()) {
      await Directory(downloadPath).create(recursive: true);
    }

    // Écrire le document au fichier
    await file.writeAsBytes(await pdf.save());

    // Ouvrir le fichier après l'avoir enregistré
    await OpenFile.open(file.path);

    // Afficher un message ou téléchargez le fichier
    print('PDF généré à l\'emplacement: ${file.path}');
  }

// ---------------------------------------------------------------------------------------
  Future<void> generateDynamicPdf({
    required String nom,
    required String prenom,
    required String age,
    required String sexe,
    required String profession,
    required String domicile,
    required String title,
    required List<String> content,
    bool isHorizontal = false,
  }) async {
    final pdf = pw.Document();
    // final image = (await rootBundle.load('assets/images/orange.png'))
    //     .buffer
    //     .asUint8List();

    final svgData = await rootBundle.loadString('assets/icons/logo_boite.svg');

    pdf.addPage(
      pw.MultiPage(
        pageFormat:
            isHorizontal ? PdfPageFormat.a5.landscape : PdfPageFormat.a5,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      height: 70,
                      width: 70,
                      child: pw.SvgImage(
                        svg: svgData, // TODO: l'image de orange doit etre ici.
                        height: 70,
                        width: 70,
                      ),
                    ),
                    if (!title.contains('Ordonnance'))
                      pw.Text(
                        "Service Médecine d'Entreprise",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if (title.contains('Ordonnance'))
                      pw.Text(
                        "Service Médecine\nd'Entreprise",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                if (title.contains('Ordonnance'))
                  pw.Text(
                    "$nom $prenom",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (title.contains('Ordonnance')) pw.SizedBox(height: 12.0),
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Ordonnance médicale",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Bulletin D'Examen Médical",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Nom: $nom",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Prénom: $prenom",
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Age: $age",
                    ),
                  ),
                ],
              ),
            if (!title.contains('Ordonnance')) pw.SizedBox(height: 10.0),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Sexe: $sexe",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Profession: $profession",
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Domicile: $domicile",
                    ),
                  ),
                ],
              ),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Avec tous nos voeux de prompt rétablissement",
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            if (title.contains('Ordonnance'))
              pw.SizedBox(
                height: 16,
              ),
            if (title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Date: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}",
                        textAlign: pw.TextAlign.start,
                      ),
                      pw.SizedBox(
                        height: 16,
                      ),
                      pw.Text(
                        "Signature et cachet",
                        textAlign: pw.TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Bamako, le ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}",
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "Bamako, le .......................20..",
                    ),
                  ),
                ],
              ),
            if (!title.contains('Ordonnance')) pw.SizedBox(height: 10.0),
            if (!title.contains('Ordonnance'))
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Le Médecin traitant",
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "Le Praticien sollicité",
                    ),
                  ),
                ],
              ),
          ],
        ),
        build: (context) {
          return [
            pw.SizedBox(
              height: 10,
            ),
            if (title.contains('Ordonnance'))
              pw.ListView.separated(
                separatorBuilder: (context, index) => pw.SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) => pw.Text(
                  textAlign: pw.TextAlign.start,
                  "${index + 1}° - ${content[index]}",
                ),
                itemCount: content.length,
              ),
            if (title.contains("Bulletin d'Examen Biologique"))
              // Content (Table)
              pw.Flexible(
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 0.5,
                      ),
                      right: pw.BorderSide(
                        width: 0.5,
                      ),
                      top: pw.BorderSide(
                        width: 0.5,
                      ),
                      left: pw.BorderSide(
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: pw.Row(children: [
                    pw.Expanded(
                      child: pw.Column(
                          //Coté droite
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 67,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  bottom: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Nature de l\'examen',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    content.join(', '),
                                    textAlign: pw.TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Text(
                                'Renseignement Clinique',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    pw.Expanded(
                      child: pw.Column(//Coté gauche
                          children: [
                        pw.Text(
                          'Résultat',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            if (title.contains("Bulletin de Radiographie"))
              // Content (Table)
              pw.Flexible(
                child: pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        width: 0.5,
                      ),
                      right: pw.BorderSide(
                        width: 0.5,
                      ),
                      top: pw.BorderSide(
                        width: 0.5,
                      ),
                      left: pw.BorderSide(
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: pw.Row(children: [
                    pw.Expanded(
                      child: pw.Column(
                          //Coté droite
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              height: 67,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  bottom: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Nature de l\'examen',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    content.join(', '),
                                    textAlign: pw.TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                  right: pw.BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Text(
                                'Renseignement Clinique',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    pw.Expanded(
                      child: pw.Column(//Coté gauche
                          children: [
                        pw.Text(
                          'Résultat',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            pw.SizedBox(
              height: 10,
            ),
          ];
        },
      ),
    );

    // Sauvegarde ou partage du PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "$title.pdf",
    );
  }

  // ________________________________________________________________________

  Future<void> generateConsultationPdfs({
    required List<String> prescriptions,
    required String nom,
    required String prenom,
    required String age,
    required String sexe,
    required String profession,
    required String domicile,
    required List<String> examenAnalyses,
    required List<String> radiographieAnalyses,
  }) async {
    // Générer l'ordonnance si des prescriptions existent
    if (prescriptions.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Ordonnance",
        content: prescriptions,
        isHorizontal: false, // Verticale
      );
    }

    // Générer un bulletin d'examen biologique si des analyses existent
    if (examenAnalyses.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Bulletin d'Examen Biologique",
        content: examenAnalyses,
        isHorizontal: true, // Horizontale
      );
    }

    // Générer un bulletin de radiographie si des analyses existent
    if (radiographieAnalyses.isNotEmpty) {
      await generateDynamicPdf(
        nom: nom,
        prenom: prenom,
        age: age,
        sexe: sexe,
        profession: profession,
        domicile: domicile,
        title: "Bulletin de Radiographie",
        content: radiographieAnalyses,
        isHorizontal: true, // Horizontale
      );
    }
  }
}
