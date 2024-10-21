import 'package:dio/dio.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/service/dio_client.dart';

class AnalyseService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Analyse>> getAllAnalyse() async {
    try {
      Response response = await apiService.getData('analyse/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Analyse.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des analyses.");
      } 
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createAnalyse(Analyse analyse) async {
    try {
      Map<String, dynamic> data = analyse.toMap();
      await apiService.postData('analyse', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateAnalyse(Analyse analyse) async {
    try {
      Map<String, dynamic> data = analyse.toMap();
      await apiService.putData('analyse/${analyse.id}', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteAnalyse(int analyseId) async {
    try {
      await apiService.deleteData('analyse/$analyseId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}