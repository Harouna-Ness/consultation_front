import 'package:dio/dio.dart';
import 'package:medstory/models/patient.dart';
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

  Future<List<Patient>> getAllPatients() async {
    try {
      Response response = await apiService.getData('admin/voirPatients');
      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((e) => Patient.fromMap(e)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des patients');
      }
    } catch (e) {
      throw Exception("Erreur lors de la requête GET patient_list: $e");
    }
  }
  
  Future<double> getAllmoyenneAge() async {
    try {
      Response response = await apiService.getData('statistics/patients-age-moyenne');
      if (response.statusCode == 200) {
        double data = response.data;
        return data;
      } else {
        throw Exception('Erreur lors de la récupération de patients-age-moyenne');
      }
    } catch (e) {
      throw Exception("Erreur lors de la requête GET patients-age-moyenne: $e");
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

  // Méthode pour modifier un patient
  Future<void> updatePatient(Map<String, dynamic> patientData) async {
    try {
      // Appel API pour modifier les informations du patient
      await apiService.putData('admin/modifierPatient', patientData);

      // Si nécessaire, actualiser le cache local
      _cachedPatientCount ??= await getPatientCount();
    } catch (e) {
      throw Exception("Erreur lors de la modification du patient : $e");
    }
  }

  Future<void> deletePatient(int patientId) async {
    try {
      await apiService.deleteData('admin/supprimerPatient/$patientId');

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