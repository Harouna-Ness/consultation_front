import 'package:dio/dio.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/dio_client.dart';

class RendezVousService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<RendezVous>> getAllRendezVous() async {
    try {
      Response response = await apiService.getData('rendezVous/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => RendezVous.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Rdv");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createRendezVous(RendezVous rendezVous) async {
    try {
      Map<String, dynamic> data = rendezVous.toMap();
      String date = '${rendezVous.date.year}-${rendezVous.date.month}-${rendezVous.date.day}';
      await apiService.postData('admin/planifier-rendez-vous?medecinId=${rendezVous.medecin.id}&patientId=${rendezVous.patient.id}&date=$date&heure=${rendezVous.heure}', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateRendezVous(RendezVous rendezVous) async {
    try {
      Map<String, dynamic> data = rendezVous.toMap();
      await apiService.putData('admin/modifierRendezVous', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteRendezVous(int rendezVousId) async {
    try {
      await apiService.deleteData('rendezVous/$rendezVousId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}