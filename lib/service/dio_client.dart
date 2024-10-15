import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // URL de base pour toutes les requêtes
  static const String baseUrl = "http://localhost:8080/";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );



  // ..interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         // Ajouter un jeton d'authentification à chaque requête
  //         String token = 'your_token_here'; // Remplacer par ton token
  //         options.headers['Authorization'] = 'Bearer $token';
  //         return handler.next(options);
  //       },
  //       onError: (DioError e, handler) {
  //         print("Erreur : ${e.message}");
  //         return handler.next(e);
  //       },
  //     ),
  //   );

  
  static Dio get dio => _dio;
}


class ApiService {
  
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> getData(String url) async {
    try {
      Response response = await _dio.get(url);
      return response;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET : $e");
    }
  }

  Future<Response> postData(String url, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      throw Exception("Erreur lors de la requête POST : $e");
    }
  }

  Future<Response> putData(String url, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.put(url, data: data);
      return response;
    } catch (e) {
      throw Exception("Erreur lors de la requête PUT : $e");
    }
  }

  Future<Response> deleteData(String url) async {
    try {
      Response response = await _dio.delete(url);
      return response;
    } catch (e) {
      throw Exception("Erreur lors de la requête DELETE : $e");
    }
  }

  // Enregistrer les données hors ligne
  Future<void> saveDataOffline(String key, String jsonString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonString);
  }

  // Charger les données hors ligne
  Future<String?> loadDataOffline(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

}
