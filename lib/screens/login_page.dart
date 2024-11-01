import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medstory/components/customTable.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/main.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService apiService = ApiService(DioClient.dio);

  Future<void> login(String username, String password) async {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.showLoader();
    }
    try {
      final response = await apiService.postData("auth/login", {
        'email': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        // S'assurer de n'avoir l'intercepteur qu'une seule fois
        DioClient.dio.interceptors.clear();
        DioClient.dio.interceptors.add(DioClient.authInterceptor(token));

        final userResponse = await apiService.getData('/users/me');

        if (userResponse.statusCode == 200) {
          final userData = userResponse.data;
          final utilisateur = Utilisateur.fromMap(userData);

          // Redirection en fonction du rôle
          if (utilisateur.role.libelle == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin').then((_) {
              context.read<MyMenuController>().changePage(0);
            });
          } else if (utilisateur.role.libelle == 'medecin') {
            Navigator.pushReplacementNamed(context, '/medecin').then((_) {
              context.read<MyMenuController>().changePage(2);
            });
          } else if (utilisateur.role.libelle == 'patient') {
            Navigator.pushReplacementNamed(context, '/patient');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rôle utilisateur non reconnu')),
            );
          }
        } else {
          throw Exception(
              "Impossible de récupérer les informations utilisateur");
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      // Gérer l'erreur de connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Center(
        child: Container(
          width: isWideScreen ? 400 : double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                height: 100,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  login(_emailController.text.trim(),
                      _passwordController.text.trim());
                },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
