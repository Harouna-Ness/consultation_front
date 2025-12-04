import 'package:dio/dio.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/service/dio_client.dart';

class MedecinService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Medecin>> getAllMedecin() async {
    try {
      Response response = await apiService.getData('admin/voirMedecins');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Medecin.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Médecins");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<Medecin> getMedecin(int id) async {
    try {
      Response response =
          await apiService.getData('admin/recupererMedecin/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return Medecin.fromMap(data);
      } else {
        throw Exception('Erreur lors de la récupération des medecin');
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  // Créer une nouveau Medecin
  Future<void> createMedecin(Medecin medecin) async {
    try {
      Map<String, dynamic> data = medecin.toMap();
      await apiService.postData('admin/creerMedecin', data);
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  // Mettre à jour un Medecin
  Future<void> updateMedecin(Medecin medecin) async {
    try {
      Map<String, dynamic> data = medecin.toMap();
      await apiService.putData('admin/modifierMedecin', data);
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  // Supprimer un Medecin
  Future<void> deleteMedecin(int medecinId) async {
    try {
      await apiService.deleteData('admin/supprimerMedecin/$medecinId');
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<List<Medecin>> getAllMedecinbySpecialite(String specialite) async {
    try {
      Response response = await apiService
          .getData('admin/voirMedecins-by-specialite?specialite=$specialite');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Medecin.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des partenaires.");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<List<String>> getAllSpecialite() async {
    try {
      Response response = await apiService.getData('admin/specialites');
      if (response.statusCode == 200) {
        List<String> data = [];
        for (var element in response.data) {
          data.add(element.toString());
        }
        return data;
      } else {
        throw Exception("Erreur lors de la récupération des partenaires.");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }
}
