import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';

class MedecinListe extends StatefulWidget {
  final List<Medecinn> medecins;
  final int count;
  const MedecinListe({super.key, required this.medecins, required this.count,});

  @override
  State<MedecinListe> createState() => _MedecinListeState();
}

class _MedecinListeState extends State<MedecinListe> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      primary: true,
      itemCount: widget.count,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1, // Épaisseur du divider
        indent: 40, // Décalage depuis la gauche
        endIndent: 40, // Décalage depuis la droite
      ),
      itemBuilder: (context, index) {
        final medecin = widget.medecins[index];
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5), // Arrondi de 5px
                child: Container(
                  width: 55,
                  height: 69,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset(
                    medecin.imageAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("${medecin.nom} ${medecin.prenom}"),
                  subtitle: Text(medecin.specialite),
                  trailing: SvgPicture.asset(
                    "assets/icons/hournav_.svg",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
