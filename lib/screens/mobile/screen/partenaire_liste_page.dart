import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/mobile/component/categorie_liste.dart';
import 'package:medstory/screens/mobile/component/partenaire_liste.dart';
import 'package:medstory/service/partenaire_service.dart';
import 'package:provider/provider.dart';

class PartenaireListePage extends StatefulWidget {
  const PartenaireListePage({super.key});

  @override
  State<PartenaireListePage> createState() => _PartenaireListePageState();
}

class _PartenaireListePageState extends State<PartenaireListePage> {
  final partenaireService = PartenaireService();
  List<String> typePatenaire = ["Tout"];

  void recupType() async {
    List<String> types = await partenaireService.getAllCategorie();
    for (var element in types) {
      setState(() {
        typePatenaire.add(element);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    recupType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset("assets/icons/MedStory.svg"),
        //
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategorieListe(
              categories: typePatenaire.map((categorie) {
                return Categorie(
                  onTap: () {
                    if (typePatenaire[0] == categorie) {
                      context.read<MyData>().fetchPartenaire();
                    } else {
                      context.read<MyData>().fetchPartenaireBytype(categorie);
                    }
                  },
                  label: categorie,
                );
              }).toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            PartenaireListe(
              partenaires: context.watch<MyData>().partenaires,
              count: context.watch<MyData>().partenaires.length,
            ),
          ],
        ),
      ),
    );
  }
}
