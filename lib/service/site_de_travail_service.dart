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
}