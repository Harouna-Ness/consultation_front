import 'package:flutter/material.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/resposive.dart';

class Pathologie extends StatefulWidget {
  const Pathologie({super.key});

  @override
  State<Pathologie> createState() => _PathologieState();
}

class _PathologieState extends State<Pathologie> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: Colors.grey,
                  height: 70,
                  width: 160,
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Responsive(
              mobile: CustomGridView(
                crossAxisCount: size.width < 650 ? 2 : 3,
                childAspectRatio: size.width < 650 ? 1.3 : 1,
                screens: [
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
              ),
              tablet: CustomGridView(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                screens: [
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
              ),
              desktop: CustomGridView(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                screens: [
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Container(
              color: Colors.grey,
              height: 300,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
