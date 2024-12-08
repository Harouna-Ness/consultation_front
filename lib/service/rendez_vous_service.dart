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
      throw Exception("Erreur : $e");
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
      throw Exception("Erreur : $e");
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
    } on DioException catch (e) {
      print(e.response!);
    } catch (e) {
      // throw Exception("Erreur : $e");
      print("Erreur : $e");
    }
  }

  Future<void> changeRendezVousStatut(
      int rdvId, Map<String, dynamic> data) async {
    try {
      await apiService.putData('admin/modifier-statut-rdv/$rdvId', data);
    } catch (e) {
      // throw Exception("Erreur : $e");
      print("créneau non disponible !");
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
