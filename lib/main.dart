import 'package:flutter/material.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/main_screen.dart';
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
      // home: const MyHomePage(),
      home: const MainScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: Text("Dossier Médical"),
  ),
  body: SingleChildScrollView(
    child: Column(
      children: [
        // Section Infos Patient
        PatientInfoSection(),
        // Section Liste des consultations
        ConsultationListSection(),
        // Section Détails de la consultation
        SelectedConsultationDetails(),
      ],
    ),
  ),
);
  }
}

Widget PatientInfoSection() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('url-to-photo'), // Photo du patient
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: Jean Dupont', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Date de naissance: 01/01/1980'),
            Text('Sexe: Homme'),
          ],
        ),
      ],
    ),
  );
}

Widget ConsultationListSection() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 5, // List de consultations
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('Consultation du consultations[index].date'),
        subtitle: Text('Médecin: consultations[index].medecin'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // Action pour afficher les détails
          },
        ),
      );
    },
  );
}

Widget SelectedConsultationDetails() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Consultation du 12/10/2024', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // Diagnostic et Symptômes
        const ExpansionTile(
          title: Text('Diagnostic et Symptômes'),
          children: [
            ListTile(
              title: Text('Diagnostic :'),
              subtitle: Text('Description du diagnostic...'),
            ),
            ListTile(
              title: Text('Symptômes :'),
              subtitle: Text('Liste des symptômes...'),
            ),
          ],
        ),

        // Bilan et Analyses
        ExpansionTile(
          title: const  Text('Bilan et Analyses'),
          children: [
            const ListTile(
              title: Text('Bilan :'),
              subtitle: Text('Type de Bilan...'),
            ),
            ListTile(
              title: Text('Analyses :'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Analyse 1'),
                  Text('- Analyse 2'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Ajouter une nouvelle analyse
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        // Traitement
        ExpansionTile(
          title: Text('Traitement'),
          children: [
            ListTile(
              title: Text('Prescription Médicale :'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Médicament 1 (Posologie)'),
                  Text('- Médicament 2 (Posologie)'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Ajouter un médicament
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
