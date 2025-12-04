import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medstory/service/dio_client.dart';

class FileUploadWidget extends StatefulWidget {
  final int dossierId;
  const FileUploadWidget({super.key, required this.dossierId});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  Uint8List? _bytes;
  String? _fileName;

  bool isImage = false;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg', 'gif', 'pdf'],
      );
      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _bytes = result.files.single.bytes;
          if (_fileName != null) {
            isImage = _fileName!.endsWith('.png') ||
                _fileName!.endsWith('.jpg') ||
                _fileName!.endsWith('.jpeg') ||
                _fileName!.endsWith('.gif');
          }
        });
        print("File selected: $_fileName");
      }
    } catch (e) {
      print('Erreur lors de la sélection du fichier: $e');
    }
  }

  Future<void> _sendFile() async {
    if (_bytes == null) return;
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(_bytes!, filename: _fileName),
      });
      Response response = await DioClient.dio.post(
        "admin/dossier-medical/${widget.dossierId}/upload",
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        print("Fichier envoyé avec succès: ${response.data}");
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fichier envoyé avec succès")),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Erreur lors de l'envoi: ${response.statusCode}")),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      print("Erreur lors de l'envoi du fichier: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        // Aperçu de l'image ou espace réservé

        if (isImage && _bytes != null)
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.memory(
              _bytes!,
              fit: BoxFit.cover,
            ),
          ),
        if (_bytes == null)
          Container(
            height: 200,
            width: 200,
            color: Colors.grey[200],
            child: const Center(child: Text("Aucune image sélectionnée")),
          ),
        if (isImage == false && _bytes != null)
          Container(
            height: 200,
            width: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Sélectionner une image"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _fileName != null ? _sendFile : null,
              child: const Text("Envoyer le fichier"),
            ),
          ],
        ),
      ],
    );
  }
}
