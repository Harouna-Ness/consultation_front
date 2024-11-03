import 'package:flutter/material.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';

class PartenaireListe extends StatefulWidget {
  final List<Partenaire> partenaires;
  final int count;
  const PartenaireListe({
    super.key,
    required this.partenaires,
    required this.count,
  });

  @override
  State<PartenaireListe> createState() => _PartenaireListeState();
}

class _PartenaireListeState extends State<PartenaireListe> {
  @override
  Widget build(BuildContext context) {
    return CustomGridView(
        crossAxisCount: 2,
        screens: widget.partenaires
            .map((element) => PartenaireItemBox(
                  partenaire: element,
                ))
            .toList());
  }
}

class PartenaireItemBox extends StatelessWidget {
  final Partenaire partenaire;
  const PartenaireItemBox({super.key, required this.partenaire});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        partenaire.nom != null?
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: tertiaryColor,
            height: 100,
            width: double.infinity,
            child: Image.asset(
              partenaire.imageAssetPath,
              fit: BoxFit.cover,
            ),
          ),
        ): ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.grey[200],
            height: 100,
            width: double.infinity,
            child: Center(
              child: Text(
                        "Partenaire",
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                      ),
            ),
          ),
        ),
        Text(
          maxLines: 1,
          "partenaire.nom",// TODO: rendre dynamique cette partie
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                overflow: TextOverflow.ellipsis
              ),
        ),
        Text(
          maxLines: 1,
          "Type de parte",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black87,
                fontSize: 14,
                overflow: TextOverflow.ellipsis
              ),
        ),
      ],
    );
  }
}
