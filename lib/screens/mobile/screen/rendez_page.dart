import 'package:flutter/material.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:provider/provider.dart';

class RendezPage extends StatefulWidget {
  const RendezPage({super.key});

  @override
  State<RendezPage> createState() => _RendezPageState();
}

class _RendezPageState extends State<RendezPage> {
  List<RendezVous> rvds = [];

  @override
  Widget build(BuildContext context) {
    rvds = context.watch<MyData>().rendezVousPatient;
    return rvds.isEmpty? 
    const Center(
              child: Text('Aucun Rendez-vous', style: TextStyle(fontSize: 24)))
    :  ListView.separated(
      itemBuilder: (context, index) => ListTile(
        title: Text('Dr ${rvds[index].medecin.nom}'),
        subtitle: Text('Date: ${rvds[index].date.day}/${rvds[index].date.month}/${rvds[index].date.year} - Heure: ${rvds[index].heure}'),
      ),
      shrinkWrap: true,
      primary: false,
      itemCount: rvds.length,
      separatorBuilder: (context, index) => const Divider(
        color: Color.fromARGB(255, 235, 214, 250),
        thickness: 1, // Épaisseur du divider
        indent: 40, // Décalage depuis la gauche
        endIndent: 40, // Décalage depuis la droite
      ),
    );
  }
}
