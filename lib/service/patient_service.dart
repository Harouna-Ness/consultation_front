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

  // Future<List<Patient>> getAllPatients() async {
  //   try {
  //     Response response = await apiService.getData('admin/voirPatients');
  //     if (response.statusCode == 200) {
  //       List data = response.data;
  //       return data.map((e) => Patient.fromMap(e)).toList();
  //     } else {
  //       throw Exception('Erreur lors de la récupération des patients');
  //     }
  //   } catch (e) {
  //     throw Exception("Erreur lors de la requête GET patient_list: $e");
  //   }
  // }

  Future<Map<String, dynamic>> getAllPatients(
      {int page = 0, int size = 10}) async {
    try {
      Response response =
          await apiService.getData('admin/voirPatients?page=$page&size=$size');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> content = data['content'];
        int totalPages = data['totalPages'];
        int totalElements = data['totalElements'];

        List<Patient> patients =
            content.map((e) => Patient.fromMap(e)).toList();
        return {
          'patients': patients,
          'totalPages': totalPages,
          'totalElements': totalElements,
        };
      } else {
        throw Exception('Erreur lors de la récupération des patients');
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<List<Patient>> fetchPatientsFromServer(
      String query, String? filter) async {
    Dio dio = DioClient.dio;
    try {
      Response response = await dio.get(
        'admin/searchPatient',
        queryParameters: {
          "query": query,
          "filter": filter,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Patient> newPatients =
            data.map((json) => Patient.fromMap(json)).toList();

        return newPatients; // Mettre à jour le provider avec les nouveaux patients
      } else {
        throw Exception('Erreur lors de la récupération des patients: ');
      }
    } catch (e) {
      print("Erreur lors de la récupération des patients : $e");
      throw Exception('Erreur lors de la récupération des patients: $e');
    }
  }

  Future<List<Patient>> getAllArchivedPatients() async {
    try {
      Response response =
          await apiService.getData('admin/voirArchivedPatients');
      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((e) => Patient.fromMap(e)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des patients');
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> archiverPatient(int patientId) async {
    try {
      await apiService.deleteData('admin/archiveyPatient/$patientId');

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
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> restaurerPatient(int patientId) async {
    try {
      await apiService.putData('admin/restaurerPatient/$patientId', {});

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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
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
      rethrow; // Relanche au niveau sup.
      // throw Exception('Erreur lors de la récupération des statistiques');
    }
    return {};
  }
}
