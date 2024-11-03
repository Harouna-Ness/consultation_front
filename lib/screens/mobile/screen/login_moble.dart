import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/main.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMoble extends StatefulWidget {
  const LoginMoble({super.key});

  @override
  State<LoginMoble> createState() => _LoginMobleState();
}

class _LoginMobleState extends State<LoginMoble> {
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
          if (utilisateur.role.libelle == 'patient') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const MainPage()), // Remplacez par votre page spécifique
              (Route<dynamic> route) =>
                  false, // Supprime toutes les routes précédentes
            );
            // Navigator.pushReplacementNamed(context, '/patient');
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

  bool isNotVisible = true;

  void showPassWord() {
    setState(() {
      isNotVisible = !isNotVisible;
    });
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
                "assets/icons/logo_mobile.svg",
                height: 120,
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                "assets/icons/MedStory.svg",
                height: 40,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: isNotVisible
                      ? IconButton(
                          onPressed: showPassWord,
                          icon: const Icon(Icons.visibility_outlined),
                        )
                      : IconButton(
                          onPressed: showPassWord,
                          icon: const Icon(Icons.visibility_off_outlined),
                        ),
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(),
                ),
                obscureText: isNotVisible,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        login(_emailController.text.trim(),
                            _passwordController.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: tertiaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
