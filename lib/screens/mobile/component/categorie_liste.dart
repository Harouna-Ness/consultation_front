import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class CategorieListe extends StatelessWidget {
  final List<Categorie> categories;
  const CategorieListe({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 25,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Categorie(
            onTap: categories[index].onTap,
            label: categories[index].label,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}

class Categorie extends StatelessWidget {
  final void Function() onTap;
  final String label;
  const Categorie({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: tertiaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
