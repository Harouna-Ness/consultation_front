import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medstory/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // URL de base pour toutes les requêtes
  static const String baseUrl = "http://localhost:8080/";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );
  static Dio get dio => _dio;

  // Méthode pour ajouter l'intercepteur, seulement si non ajouté
  static InterceptorsWrapper authInterceptor(String token) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401 &&
            navigatorKey.currentContext != null) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => AlertDialog(
              title: const Text('Session Expirée'),
              content: const Text(
                'Votre session a expiré, veuillez vous reconnecter.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        if (e.response?.statusCode == 403 &&
            navigatorKey.currentContext != null) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => AlertDialog(
              title: const Text('Session Expirée'),
              content: const Text(
                'Votre session a expiré, veuillez vous reconnecter.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        handler.next(e);
      },
    );
  }
}

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> getData(String url) async {
    try {
      Response response = await _dio.get(url);
      return response;
    } on DioException catch (e) {
      print("l'erreur ${e.response!}");
      return e.response!;
    } catch (e) {
      throw Exception("Erreur lors de la requête GET : $e");
    }
  }

  Future<Response> postData(String url, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      print(e.response!);
      return e.response!;
    } catch (e) {
      throw Exception("Erreur lors de la requête POST : $e");
    }
  }

  Future<Response> putData(String url, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.put(url, data: data);
      return response;
    } on DioException catch (e) {
      print("l'erreur ${e.response!}");
      return e.response!;
    } catch (e) {
      throw Exception("Erreur lors de la requête PUT : $e");
    }
  }

  Future<Response> deleteData(String url) async {
    try {
      Response response = await _dio.delete(url);
      return response;
    } on DioException catch (e) {
      print("l'erreur ${e.response!}");
      return e.response!;
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
