import 'package:dio/dio.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/dio_client.dart';

class TypeConsultationService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<TypeDeConsultation>> getAllTypeDeConsultation() async {
    try {
      Response response = await apiService.getData('admin/voirDirections');
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
}