import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/mobile/component/categorie_liste.dart';
import 'package:medstory/screens/mobile/component/medecin_liste.dart';
import 'package:medstory/service/medecin_service.dart';
import 'package:provider/provider.dart';

class MedecinListPage extends StatefulWidget {
  const MedecinListPage({super.key});

  @override
  State<MedecinListPage> createState() => _MedecinListPageState();
}

class _MedecinListPageState extends State<MedecinListPage> {
  final medecinService = MedecinService();

  List<String> specialiteListe = ["Tout"];

  void recupSpeciatlite() async {
    List<String> specialites = await medecinService.getAllSpecialite();
    for (var element in specialites) {
      setState(() {
        specialiteListe.add(element);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    recupSpeciatlite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset("assets/icons/MedStory.svg"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategorieListe(
              categories: specialiteListe.map((categorie) {
                return Categorie(
                  onTap: () {
                    if (specialiteListe[0] == categorie) {
                      context.read<MyData>().fetchMedecins();
                    } else {
                      context.read<MyData>().fetchMedecinsbySpeciatilite(categorie);
                    }
                  },
                  label: categorie,
                );
              }).toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            MedecinListe(
              medecins: context.watch<MyData>().medecins,
              count: context.watch<MyData>().medecins.length,
            ),
          ],
        ),
      ),
    );
  }
}
