import 'package:dio/dio.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/service/dio_client.dart';

class StatutService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Statut>> getAllStatuts() async {
    try {
      Response response = await apiService.getData('admin/voirStatuts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Statut.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des statuts");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createStatut(Statut statut) async {
    try {
      Map<String, dynamic> data = statut.toMap();
      await apiService.postData('admin/creerStatut', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateStatut(Statut statut) async {
    try {
      Map<String, dynamic> data = statut.toMap();
      await apiService.putData('admin/modifierStatut', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteStatut(int statutId) async {
    try {
      await apiService.deleteData('admin/supprimerStatut/$statutId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}
