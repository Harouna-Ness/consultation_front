import 'dart:io';
import 'package:medstory/models/consultation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

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
              pw.Text('Diagnostic: ${consultation.diagnostic}'),
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
}
