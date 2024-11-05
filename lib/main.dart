import 'package:flutter/material.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/screens/login_page.dart';
import 'package:medstory/screens/main_screen.dart';
import 'package:medstory/screens/medecin_portail.dart';
import 'package:medstory/screens/mobile/screen/login_moble.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';
import 'package:medstory/screens/splash_sreen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyMenuController(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '', // Route de démarrage
      routes: {
        '': (context) => const MyHomePage(), 
        '': (context) => const MyHomePage(), // TODO: decommenter cette ligne.
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const MainScreen(),
        '/medecin': (context) => const MedecinPortail(),
        '/patient': (context) => const MainPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MainPage(),
      // home: const LoginPage(),
      // home: const MedecinPortail(),
      // home: const LoginPage(),
      // home: const SplashScreen(),
      // home: const MyHomePage(),// TODO: decommenter cette ligne.
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Utilisateur? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    // goToUserPortail();
    super.initState();
  }

  void goToUserPortail() {
    currentUser = context.watch<MyData>().currentUser;
    if (currentUser != null) {
      if (currentUser!.role.libelle.contains("admin")) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (currentUser!.role.libelle.contains("medecin")) {
        Navigator.pushReplacementNamed(context, '/medecin');
      } else if (currentUser!.role.libelle.contains("patient")) {
        Navigator.pushReplacementNamed(context, '/patient');
      }
    } else {
      //Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SplashScreen();
    } else if (Platform.isAndroid) {
      return const LoginMoble();
    } else {
      return Container();
    }
  }
}
