import 'package:dio/dio.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/service/dio_client.dart';

class SiteDeTravailService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Sitedetravail>> getAllSite() async {
    try {
      Response response = await apiService.getData('admin/voirSiteDeTravails');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Sitedetravail.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Site de travail");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createSitedetravail(Sitedetravail sitedetravail) async {
    try {
      Map<String, dynamic> data = sitedetravail.toMap();
      await apiService.postData('admin/creerSiteDeTravail', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateSitedetravail(Sitedetravail sitedetravail) async {
    try {
      Map<String, dynamic> data = sitedetravail.toMap();
      await apiService.putData('admin/modifierSiteDeTravail', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteSitedetravail(int sitedetravailId) async {
    try {
      await apiService.deleteData('admin/supprimeSiteDeTravail/$sitedetravailId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}