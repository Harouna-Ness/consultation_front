import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.screens,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final List<Widget> screens;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: screens.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => screens[index],
    );
  }
}
