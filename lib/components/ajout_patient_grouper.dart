import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/utils/lodder.dart';

class AjoutPatientGrouper extends StatefulWidget {
  const AjoutPatientGrouper({super.key});

  @override
  State<AjoutPatientGrouper> createState() => _AjoutPatientGrouperState();
}

class _AjoutPatientGrouperState extends State<AjoutPatientGrouper> {
  String? _fileName;
  List<int>? _bytes;
  List rapport = [];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _bytes = result.files.single.bytes;
        });
        print("object file is here::${_bytes.toString()}");
      }
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de la sélection du fichier: $e');
    }
  }

  Future<void> envoyerFichier() async {
    context.showLoader();
    if (_bytes != null) {
      if (_bytes!.isNotEmpty) {
        final formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            _bytes!,
            filename: _fileName,
          ),
        });

        try {
          Response response = await DioClient.dio
              .post("admin/creerPatient-via-fichier", data: formData);

          if (response.statusCode == 200) {
            setState(() {
              rapport = response.data;
            });
            context.hideLoader();
            print(rapport);
          } else {
            context.hideLoader();
            context.showError(
                'Erreur lors du téléchargement de $_fileName : ${response.statusCode}');
            print(
                'Erreur lors du téléchargement de $_fileName : ${response.statusCode}');
          }
        } catch (e) {
          context.showError('Erreur lors du téléchargement de $_fileName : $e');
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Box(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Documents.svg",
                            color: _fileName == null
                                ? Colors.grey
                                : const Color.fromARGB(255, 90, 147, 92),
                            height: 80,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _fileName != null
                              ? Text(
                                  _fileName!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _pickFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  'Importer un fichier Excel',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                onPressed:
                                    _fileName != null ? envoyerFichier : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tertiaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  'Ajouter les patients via ce fichier',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Box(
              child: Container(
                color: const Color.fromARGB(255, 241, 241, 241),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 5,
                    indent: 2,
                    endIndent: 0,
                    color: Colors.white,
                  ),
                  itemCount: rapport.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      rapport[index],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
