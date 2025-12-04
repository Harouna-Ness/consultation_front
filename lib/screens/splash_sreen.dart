import 'package:flutter/material.dart';
import 'package:medstory/models/auth_service.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> splashScreenkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = await authService.checkToken();

    if (token != null) {
      print("Splash_screen::: le token: $token");
      DioClient.dio.interceptors.clear();
      DioClient.dio.interceptors.add(DioClient.authInterceptor(token));

      try {
        // Effectuer la requête pour récupérer les informations utilisateur
        final response = await DioClient.dio.get('/users/me');
        if (response.statusCode == 200) {
          final userData = response.data;
          final role = userData['role']['libelle'];
          print("Le role du user: $role");

          final utilisateur = Utilisateur.fromMap(userData);

          context.read<MyData>().setCurrentUser(utilisateur);

          if (utilisateur.role.libelle == 'medecin') {
            await context.read<MyData>().getCurrentMedecin(utilisateur.id!);
            await context
                .read<MyData>()
                .fetchRendezVousmedecin(utilisateur.id!);
          }

          Navigator.pushReplacementNamed(
              splashScreenkey.currentContext!, '/admin');

          // // Redirection en fonction du rôle
          // if (role == 'admin') {
          //   Navigator.pushReplacementNamed(
          //       splashScreenkey.currentContext!, '/admin');
          // } else if (role == 'medecin') {
          //   Navigator.pushReplacementNamed(
          //       splashScreenkey.currentContext!, '/medecin');
          // } else if (role == 'patient') {
          //   Navigator.pushReplacementNamed(
          //       splashScreenkey.currentContext!, '/patient');
          // } else {
          //   Navigator.pushReplacementNamed(
          //       splashScreenkey.currentContext!, '/LoginPage');
          // }
        } else {
          // Navigator.pushReplacementNamed(context, '/LoginPage');
        }
      } catch (e) {
        // Navigator.pushReplacementNamed(context, '/LoginPage');
      }
    } else {
      print("Splash_screen::: le token n'est pas disponible: $token ");
      // Navigator.pushReplacementNamed(context, '/LoginPagePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: splashScreenkey,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}







// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthentication();
//   }

//   Future<void> _checkAuthentication() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token != null) {
//       print("object::: le token: $token");
//       // Ajouter le token à l'en-tête Authorization pour toutes les futures requêtes
//       // DioClient.dio.options.headers['Authorization'] = 'Bearer $token';
//       // DioClient.addAuthInterceptor(token);
//       DioClient.dio.interceptors.clear();
//       DioClient.dio.interceptors.add(DioClient.authInterceptor(token));

//       try {
//         // Effectuer la requête pour récupérer les informations utilisateur
//         final response = await DioClient.dio.get('/users/me');
//         if (response.statusCode == 200) {
//           final userData = response.data;
//           final role = userData['role']['libelle'];

//           // Redirection en fonction du rôle
//           if (role == 'admin') {
//             Navigator.pushReplacementNamed(context, '/admin');
//           } else if (role == 'medecin') {
//             Navigator.pushReplacementNamed(context, '/medecin');
//           } else if (role == 'patient') {
//             Navigator.pushReplacementNamed(context, '/patient');
//           } else {
//             Navigator.pushReplacementNamed(context, '/login');
//           }
//         } else {
//           Navigator.pushReplacementNamed(context, '/login');
//         }
//       } catch (e) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } else {
//       print("object::: le token disparu: $token ");
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
