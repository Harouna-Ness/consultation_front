import 'package:flutter/material.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/main_screen.dart';
import 'package:medstory/screens/medecin_portail.dart';
import 'package:provider/provider.dart';

void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MedecinPortail(),
      // home: const MainScreen(),
    );
  }
}
