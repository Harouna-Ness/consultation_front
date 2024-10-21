import 'package:dio/dio.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/service/dio_client.dart';

class StatutPatientService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<StatutPatient>> getAllStatutPatient() async {
    try {
      Response response =
          await apiService.getData('admin/voirStatutPatients');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => StatutPatient.fromMap(e)).toList();
      } else {
        throw Exception(
            "Erreur lors de la récupération des Statut Patients");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

   Future<void> createStatutPatient(StatutPatient statutPatient) async {
    try {
      Map<String, dynamic> data = statutPatient.toMap();
      await apiService.postData('admin/CreerStatusPatient', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateStatutPatient(StatutPatient statutPatient) async {
    try {
      Map<String, dynamic> data = statutPatient.toMap();
      await apiService.putData('admin/modifierStatutPatient', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteStatutPatient(int statutPatientId) async {
    try {
      await apiService.deleteData('admin/supprimeStatutPatient/$statutPatientId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}
