import 'package:dio/dio.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultationService {
  final apiService = ApiService(DioClient.dio);
  int? _cachedconsultationCount;

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
      Response response = await apiService.getData('admin/voirNombreconsultation');
      _cachedconsultationCount = response.data;
      // print("hors cache:::::: $_cachedconsultationCount");
      // Sauvegarder le nombre d'utilisateurs dans Shared Preferences
      await prefs.setInt('consultation_count', _cachedconsultationCount!);
      return _cachedconsultationCount!;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET consultation_count : $e");
    }
  }
}