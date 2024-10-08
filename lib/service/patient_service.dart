import 'package:dio/dio.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientService {
  
  int? _cachedPatientCount;
  final apiService = ApiService(DioClient.dio);

  Future<int> getPatientCount() async {
    // Vérifier si le nombre d'utilisateurs est déjà mis en cache
    if (_cachedPatientCount != null) {
      return _cachedPatientCount!;
    }

    // Charger le nombre d'utilisateurs à partir de Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cachedPatientCount = prefs.getInt('patient_count');

    if (_cachedPatientCount != null) {
      
      return _cachedPatientCount!;
    }

    // Si pas de données en cache, récupérer depuis l'API
    try {
      Response response = await apiService.getData('admin/voirNombrePatient');
      _cachedPatientCount = response.data;

      // Sauvegarder le nombre d'utilisateurs dans Shared Preferences
      await prefs.setInt('patient_count', _cachedPatientCount!);
      return _cachedPatientCount!;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET patient_count: $e");
    }
  }

  Future<void> addPatient(Map<String, dynamic> patientData) async {
    try {
      await apiService.postData('admin/creerPatient', patientData);

      // Incrémenter le compteur et mettre à jour le cache
      if (_cachedPatientCount != null) {
        _cachedPatientCount = _cachedPatientCount! + 1;
      } else {
        _cachedPatientCount = await getPatientCount();
      }

      // Mettre à jour le nombre d'utilisateurs dans Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('patient_count', _cachedPatientCount!);
    } catch (e) {
      throw Exception("Erreur lors de l'ajout de l'utilisateur : $e");
    }
  }

  Future<void> deletePatient(int patientId) async {
    try {
      await apiService.deleteData('Patients/$patientId');

      // Décrémenter le compteur et mettre à jour le cache
      if (_cachedPatientCount != null) {
        _cachedPatientCount = _cachedPatientCount! - 1;
      } else {
        _cachedPatientCount = await getPatientCount();
      }

      // Mettre à jour le nombre d'utilisateurs dans Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('patient_count', _cachedPatientCount!);
    } catch (e) {
      throw Exception("Erreur lors de la suppression de l'utilisateur : $e");
    }
  }
}