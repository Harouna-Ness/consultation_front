import 'package:flutter/material.dart';
import 'package:medstory/constantes.dart';

class DateBtnFilter extends StatelessWidget {
  const DateBtnFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[100],
      child: Row(
        children: [
          const SizedBox(
            width: 7,
          ),
          const Icon(
            Icons.date_range_outlined,
            color: primaryColor,
            size: 17,
          ),
          if (size.width > 350)
            const SizedBox(
              width: 7,
            ),
          if (size.width > 350)
            Text(
              "ce mois",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                    color: Colors.black,
                  ),
            ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down),
          )
        ],
      ),
    );
  }
}
