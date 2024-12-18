import 'package:dio/dio.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientService {
  int? _cachedPatientCount;
  final apiService = ApiService(DioClient.dio);

  Future<int> getPatientCount() async {
    try {
      Response response = await apiService.getData('admin/voirNombrePatient');
      return response.data;
    } catch (e) {
      print("Erreur lors de la requête GET patient_count: $e");
      return -1;
      // throw Exception("Erreur lors de la requête GET patient_count: $e");
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

  Future<Patient> getPatient(int id) async {
    try {
      Response response =
          await apiService.getData('admin/recupererPatient/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return Patient.fromMap(data);
      } else {
        throw Exception('Erreur lors de la récupération des patients');
      }
    } catch (e) {
      throw Exception("Erreur lors de la requête GET patient_list: $e");
    }
  }

  Future<double> getAllmoyenneAge() async {
    try {
      Response response =
          await apiService.getData('statistics/patients-age-moyenne');
      if (response.statusCode == 200) {
        double data = response.data;
        return data;
      } else {
        throw Exception(
            'Erreur lors de la récupération de patients-age-moyenne');
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

  Future<Map<String, int>> fetchStatistics() async {
    try {
      final response = await apiService.getData('statistics/patients-by-sex');
      if (response.statusCode == 200) {
        return Map<String, int>.from(response.data);
      }
    } catch (e) {
      print('Erreur : $e');
    }
    return {};
  }

  Future<Map<String, int>> getAgeRange() async {
    try {
      final response = await apiService.getData('statistics/age-range');
      if (response.statusCode == 200) {
        return Map<String, int>.from(response.data);
      }
    } catch (e) {
      print('Erreur : $e');
    }
    return {};
  }

  Future<Map<String, int>> fetchPatientsBySite() async {
    try {
      final response = await apiService.getData('statistics/patients-by-site');
      if (response.statusCode == 200) {
        return Map<String, int>.from(response.data);
      }
    } catch (e) {
      print('Erreur : $e');
    }
    return {};
  }

  Future<Map<String, int>> getPatientsByProfession() async {
    try {
      final response =
          await apiService.getData('statistics/patients-by-profession');
      if (response.statusCode == 200) {
        return (response.data as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as int),
        );
      }
    } catch (e) {
      print('Erreur : $e');
      // throw Exception('Erreur lors de la récupération des statistiques');
    }
    return {};
  }

  Future<Map<String, int>> getPatientsByTypeDeContrat() async {
    try {
      final response =
          await apiService.getData('statistics/patients-by-typeDeContrat');
      if (response.statusCode == 200) {
        return (response.data as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as int),
        );
      }
    } catch (e) {
      print('Erreur : $e');
      // throw Exception('Erreur lors de la récupération des statistiques');
    }
    return {};
  }
}
