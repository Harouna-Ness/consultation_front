import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';

class TotalNbrDashboard extends StatelessWidget {
  const TotalNbrDashboard({super.key, required this.color, required this.svgIc, required this.total, required this.label});

  final Color color;
  final String svgIc;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(5),),
        boxShadow: [
          BoxShadow(
            blurRadius: .1,
            spreadRadius: .1,
            offset: Offset(0, 1),
            blurStyle: BlurStyle.outer,
            color: Colors.grey,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle,),
              child: Center(
                child: SvgPicture.asset(
                  svgIc,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: defaultPadding * 2,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  total == -1 ?
                  Text(
                    "-",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black),
                  ):
                  Text(
                    total.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
