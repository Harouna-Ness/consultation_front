import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ----------------------------Api Service----------------------------
class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));

  Future<void> getUserById(BuildContext context, int id) async {
    try {
      final response = await _dio.get('/users/$id');
      print('Utilisateur trouvé : ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        // Gestion des erreurs avec la réponse du backend
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          final message =
              errorData['message'] ?? 'Une erreur inconnue est survenue.';
          final errorCode = errorData['errorCode'] ?? 'UNKNOWN_ERROR';

          // Appeler une méthode pour gérer l'erreur
          _handleError(context, errorCode, message);
        } else {
          _showSnackbar(context, 'Erreur inattendue : ${e.response}');
        }
      } else {
        // Erreur réseau
        _showSnackbar(context, 'Erreur réseau : ${e.message}');
      }
    } catch (e) {
      _showSnackbar(context, 'Erreur inconnue : $e');
    }
  }

  void _handleError(BuildContext context, String errorCode, String message) {
    switch (errorCode) {
      case 'INVALID_ARGUMENT':
        _showAlertDialog(context, 'Erreur de validation', message);
        break;
      case 'USER_NOT_FOUND':
        _showSnackbar(
            context, 'Utilisateur introuvable. Veuillez vérifier l\'ID.');
        break;
      default:
        _showSnackbar(context, 'Erreur : $message');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// ----------------------------Main page----------------------------

// TODO: Pour permettre le rafraichissement de page, decommente cette partie.
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AuthService(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Gestion des Produits',
//         initialRoute: '/',
//         routes: {
//           '/': (context) => Consumer<AuthService>(
//                 builder: (context, auth, _) =>
//                     auth.isAuthenticated ? DashboardPage() : LoginPage(),
//               ),
//           '/DashboardPage': (context) => DashboardPage(),
//           '/LoginPage': (context) => LoginPage(),
//         },
//       ),
//     );
//   }
// }