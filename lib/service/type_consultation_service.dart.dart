import 'package:dio/dio.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/dio_client.dart';

class TypeConsultationService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<TypeDeConsultation>> getAllTypeDeConsultation() async {
    try {
      Response response = await apiService.getData('admin/voir-types-consultation');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => TypeDeConsultation.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des Type de consultation");
      } 
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createTypeDeConsultation(TypeDeConsultation typeDeConsultation) async {
    try {
      Map<String, dynamic> data = typeDeConsultation.toMap();
      await apiService.postData('admin/creer-type-consultation', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateTypeDeConsultation(TypeDeConsultation typeDeConsultation) async {
    try {
      Map<String, dynamic> data = typeDeConsultation.toMap();
      await apiService.putData('admin/modifier-type-consultation', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteTypeDeConsultation(int typeDeConsultationId) async {
    try {
      await apiService.deleteData('admin/supprimer-type-de-consultation/$typeDeConsultationId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}