import 'package:dio/dio.dart';
import 'package:medstory/models/partenaire.dart';
import 'package:medstory/service/dio_client.dart';

class PartenaireService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<Partenaire>> getAllPartenaires() async {
    try {
      Response response = await apiService.getData('partenaires/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Partenaire.fromJson(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des partenaires.");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<List<Partenaire>> getAllPartenairesBytype(String type) async {
    try {
      Response response = await apiService.getData('partenaires/type/$type');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Partenaire.fromJson(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des partenaires.");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<List<String>> getAllCategorie() async {
    try {
      Response response = await apiService.getData('partenaires/types');
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
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createPartenaire(Partenaire partenaire) async {
    try {
      Map<String, dynamic> data = partenaire.toJson();
      await apiService.postData('partenaires', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updatePartenaire(Partenaire partenaire) async {
    try {
      Map<String, dynamic> data = partenaire.toJson();
      await apiService.putData('partenaires/${partenaire.id}', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deletePartenaire(int partenaireId) async {
    try {
      await apiService.deleteData('partenaires/$partenaireId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}
