import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      child: Column(
        children: [
          DrawerHeader(
            child: SvgPicture.asset("assets/icons/logo.svg"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/dashbordd.svg",
            press: () => {
              setState(
                () {
                  context.read<MyMenuController>().changePage(0);
                  context.read<MyMenuController>().closeDrawer();
                },
              )
            },
          ),
          DrawerListTile(
            title: "Patients",
            svgSrc: "assets/icons/patients.svg",
            press: () => {
              setState(() {
                context.read<MyMenuController>().changePage(1);
                context.read<MyMenuController>().closeDrawer();
              })
            },
          ),
          DrawerListTile(
            title: "Consultation",
            svgSrc: "assets/icons/consultation.svg",
            press: () => {
              context.read<MyMenuController>().changePage(2),
              context.read<MyMenuController>().closeDrawer(),
            },
          ),
          DrawerListTile(
            title: "Rendez-vous",
            svgSrc: "assets/icons/rendezvous.svg",
            press: () => {
              context.read<MyMenuController>().changePage(3),
              context.read<MyMenuController>().closeDrawer(),
            },
          ),
          const Spacer(),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => {
              context.read<MyMenuController>().closeDrawer(),
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 1.0,
      leading: SvgPicture.asset(
        svgSrc,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
