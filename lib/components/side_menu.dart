import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';
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
      backgroundColor: Colors.white,
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
            title: "Docteurs",
            svgSrc: "assets/icons/docIcone.svg",
            press: () => {
              setState(() {
                context.read<MyMenuController>().changePage(6);
                context.read<MyMenuController>().closeDrawer();
              })
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
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => {
              context.read<MyMenuController>().changePage(5),
              context.read<MyMenuController>().closeDrawer(),
            },
          ),
          const Spacer(),
          // profil tile
          Row(
            children: [
              Expanded(
                child: ListTile(
                  onTap: () {},
                  horizontalTitleGap: 1.0,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: SvgPicture.asset(
                      "assets/icons/person_icon.svg",
                      height: 20,
                    ),
                  ),
                  title: const Text(
                    "  Prénom Nom",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: const Text("  Admin", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),),
                ),
              ),
              // deconnxion button
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/Logout.svg",
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
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
