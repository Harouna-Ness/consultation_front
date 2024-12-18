import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultationService {
  final apiService = ApiService(DioClient.dio);
  int? _cachedconsultationCount;

  Future<void> creerConsultation(
      Map<String, dynamic> data, String emailPatient) async {
    try {
      await apiService.postData(
          "medecin/creerConsultation/$emailPatient", data);
    } catch (e) {
      throw Exception("Erreur lors de la requête GET consultation_count : $e");
    }
  }

  Future<List<Consultation>> getAllConsultation() async {
    try {
      Response response = await apiService.getData('medecin/consultation');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((e) => Consultation.fromMap(e)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des consultations");
      }
    } catch (e) {
      throw Exception("Erreur : $e");
    }
  }

  Future<int> getConsultationCount() async {
    // Vérifier si le nombre d'utilisateurs est déjà mis en cache
    if (_cachedconsultationCount != null) {
      return _cachedconsultationCount!;
    }

    // Charger le nombre d'utilisateurs à partir de Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cachedconsultationCount = prefs.getInt('consultation_count');

    if (_cachedconsultationCount != null) {
      // print("dans le cache:::::: $_cachedconsultationCount");
      return _cachedconsultationCount!;
    }

    // Si pas de données en cache, récupérer depuis l'API
    try {
      Response response =
          await apiService.getData('admin/voirNombreconsultation');
      _cachedconsultationCount = response.data;
      // print("hors cache:::::: $_cachedconsultationCount");
      // Sauvegarder le nombre d'utilisateurs dans Shared Preferences
      await prefs.setInt('consultation_count', _cachedconsultationCount!);
      return _cachedconsultationCount!;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET consultation_count : $e");
    }
  }

  Future<List<Consultation>> fetchConsultations({DateTimeRange? range}) async {
    try {
      final response = await DioClient.dio.get(
        "statistics/by-date?startDate=${range!.start.year}-${range.start.month}-${range.start.day}&endDate=${range.end.year}-${range.end.month}-${range.end.day}",
      );

      List data = response.data as List;
      print(data);
      print(
          "star: ${range!.start.year}-${range!.start.month}-${range!.start.day}");
      print("end: ${range.end.year}-${range.end.month}-${range.end.day}");
      return data.map((e) => Consultation.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Erreur lors de la récupération des consultations: $e");
    }
  }

  Future<Map<String, dynamic>> fetchConsultationsByMotif({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await DioClient.dio.get(
      'statistics/by-motif',
      queryParameters: {
        'startDate': startDate.toIso8601String().split('T').first,
        'endDate': endDate.toIso8601String().split('T').first,
      },
    );
    return response.data;
  }
}
