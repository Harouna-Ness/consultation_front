import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/screens/main_screen.dart';
import 'package:medstory/screens/medecin_portail.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Simulated lists for demonstration
  final List<Map<String, dynamic>> medecins = [
    {
      'email': 'medecin@example.com',
      'motDePasse': 'pass1234',
      'role': 'medecin'
    },
  ];
  final List<Map<String, dynamic>> admins = [
    {'email': 'admin@example.com', 'motDePasse': 'pass1234', 'role': 'admin'},
  ];

  // Function to handle login
  void _login() {
    String email = _emailController.text.trim();
    String motDePasse = _passwordController.text.trim();

    // Check in the list of medecins
    final medecin = medecins.firstWhere(
      (user) => user['email'] == email && user['motDePasse'] == motDePasse,
      orElse: () => <String, dynamic>{}, // retourne un Map vide si non trouvé
    );

    // Check in the list of patients if not found in medecins
    final admin = medecin.isEmpty
        ? admins.firstWhere(
            (user) =>
                user['email'] == email && user['motDePasse'] == motDePasse,
            orElse: () =>
                <String, dynamic>{}, // retourne un Map vide si non trouvé
          )
        : <String, dynamic>{};

    if (medecin.isNotEmpty || admin.isNotEmpty) {
      final user = medecin.isNotEmpty ? medecin : admin;
      final role = user['role'];

      // Navigate based on the user role
      if (role == 'medecin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              context.read<MyMenuController>().changePage(8);
              return const MedecinPortail();
            },
          ),
        );
      } else if (role == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              context.read<MyMenuController>().changePage(0);
              return const MainScreen();}
          ),
        );
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
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
                onPressed: _login,
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
