import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstory/models/app_exception.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/dio_client.dart';

class RendezVousService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<RendezVous>> getAllRendezVous() async {
    try {
      Response response = await apiService.getData('rendezVous/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);
        return data.map((e) => RendezVous.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Rdv");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<List<RendezVous>> getAllRendezVousbypatient(int patientId) async {
    try {
      Response response =
          await apiService.getData('admin/rendez-vous/$patientId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => RendezVous.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Rdv");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<List<RendezVous>> getAllRendezVousbyMedecin(int medecinId) async {
    try {
      Response response =
          await apiService.getData('admin/rendez-vous-par/$medecinId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => RendezVous.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Rdv");
      }
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> createRendezVous(RendezVous rendezVous) async {
    try {
      Map<String, dynamic> data = rendezVous.toMap();
      String date =
          '${rendezVous.date.year}-${rendezVous.date.month.toString().padLeft(2, '0')}-${rendezVous.date.day.toString().padLeft(2, '0')}';
      print(
        'admin/planifier-rendez-vous?medecinId=${rendezVous.medecin.id}&patientId=${rendezVous.patient.id}&date=$date&heure=${rendezVous.heure}',
      );
      print("data");
      print(data);
      await apiService.postData(
          'admin/planifier-rendez-vous?medecinId=${rendezVous.medecin.id}&patientId=${rendezVous.patient.id}&date=$date&heure=${rendezVous.heure}',
          data);
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> changeRendezVousStatut(
      int rdvId, Map<String, dynamic> data) async {
    try {
      await apiService.putData('admin/modifier-statut-rdv/$rdvId', data);
    } catch (e) {
      // throw Exception("Erreur : $e");
      // print("créneau non disponible !");
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> updateRendezVous(RendezVous rendezVous) async {
    try {
      Map<String, dynamic> data = rendezVous.toMap();
      await apiService.putData('admin/modifierRendezVous', data);
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  Future<void> deleteRendezVous(int rendezVousId) async {
    try {
      await apiService.deleteData('rendezVous/$rendezVousId');
    } catch (e) {
      rethrow; // Relanche au niveau sup.
    }
  }

  // Fonction qui appelle l'API pour modifier la date et l'heure du rendez-vous
  Future<RendezVous> modifierDateRdv({
    required RendezVous rdv,
    required DateTime date,
    required String heure,
  }) async {
    // Format de la date en ISO "yyyy-MM-dd"
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      Response response = await DioClient.dio.put(
        'admin/modifier-date-rdv/',
        queryParameters: {
          'date': dateStr,
          'heure': heure,
        },
        data: rdv.toMap(),
      );
      if (response.statusCode == 200) {
        return RendezVous.fromMap(response.data);
      } else {
        throw Exception('Erreur lors de la mise à jour du rendez-vous');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw _handleError(e.response!); // Gestion des erreurs par code statut
      }

      throw AppException("Erreur réseau !");
    }
  }

  AppException _handleError(Response response) {
    int statusCode = response.statusCode ?? 0;

    switch (statusCode) {
      case 400:
        throw AppException(
            'Requête invalide : ${response.data['message'] ?? 'Erreur inconnue'}');
      case 401:
        throw AppException(
            'Non autorisé : ${response.data['description'] ?? 'Authentification requise'}');
      case 403:
        {
          if (response.data != null) {
            throw AppException(
                'Accès refusé : ${response.data['description'] ?? "Vous n’avez pas les droits nécessaires"}');
          }
          throw AppException('Accès refusé : ${response.statusCode}');
        }
      case 404:
        throw AppException(
            'Ressource non trouvée : ${response.data['message'] ?? 'URL incorrecte ou ressource absente'}');
      case 409:
        throw AppException(
            'Doublon : ${response.data['message'] ?? 'Ressource déjà utilisé'}');
      case 500:
        throw AppException(
            'Erreur interne du serveur : ${response.data['detail'] ?? 'Veuillez réessayer plus tard'}');
      default:
        throw AppException(
            'Erreur inattendue ($statusCode) : ${response.data['message'] ?? response.statusMessage}');
    }
  }
}
