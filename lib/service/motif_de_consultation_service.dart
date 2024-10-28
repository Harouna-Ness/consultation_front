import 'package:dio/dio.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/service/dio_client.dart';

class MotifDeConsultationService {
  final ApiService apiService = ApiService(DioClient.dio);

  Future<List<MotifDeConsultation>> getAllMotifDeConsultation() async {
    try {
      Response response = await apiService.getData('motif-de-consultation/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => MotifDeConsultation.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des motifs de consultation");
      } 
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> createMotifDeConsultation(MotifDeConsultation motifDeConsultation) async {
    try {
      Map<String, dynamic> data = motifDeConsultation.toMap();
      await apiService.postData('motif-de-consultation', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> updateMotifDeConsultation(MotifDeConsultation motifDeConsultation) async {
    try {
      Map<String, dynamic> data = motifDeConsultation.toMap();
      await apiService.putData('motif-de-consultation/${motifDeConsultation.id}', data);
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<void> deleteMotifDeConsultation(int motifDeConsultationId) async {
    try {
      await apiService.deleteData('motif-de-consultation/$motifDeConsultationId');
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }
}