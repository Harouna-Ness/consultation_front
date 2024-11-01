import 'package:flutter/material.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      // Ajouter le token à l'en-tête Authorization pour toutes les futures requêtes
      // DioClient.dio.options.headers['Authorization'] = 'Bearer $token';
      // DioClient.addAuthInterceptor(token);
      DioClient.dio.interceptors.clear();
      DioClient.dio.interceptors.add(DioClient.authInterceptor(token));

      try {
        // Effectuer la requête pour récupérer les informations utilisateur
        final response = await DioClient.dio.get('/users/me');
        if (response.statusCode == 200) {
          final userData = response.data;
          final role = userData['role']['libelle'];

          // Redirection en fonction du rôle
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (role == 'medecin') {
            Navigator.pushReplacementNamed(context, '/medecin');
          } else if (role == 'patient') {
            Navigator.pushReplacementNamed(context, '/patient');
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
