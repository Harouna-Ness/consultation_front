import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/main.dart';
import 'package:medstory/models/auth_service.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String role = "-";

  @override
  Widget build(BuildContext context) {
    role = context.watch<MyData>().currentUser?.role.libelle ?? "-";

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 1,
      child: Column(
        children: [
          DrawerHeader(
            child: SvgPicture.asset("assets/icons/logo.svg"),
          ),
          DrawerListTile(
            title: "Tableau de bord",
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
          // Ongles admin
          if (role == "admin")
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
          if (role == "admin")
            DrawerListTile(
              title: "Rendez-vous",
              svgSrc: "assets/icons/rendezvous.svg",
              press: () => {
                context.read<MyMenuController>().changePage(3),
                context.read<MyMenuController>().closeDrawer(),
              },
            ),
          // Ongles médecin
          if (role == "medecin")
            DrawerListTile(
              title: "Consultation",
              svgSrc: "assets/icons/consultation.svg",
              press: () => {
                context.read<MyMenuController>().changePage(2),
                context.read<MyMenuController>().closeDrawer(),
              },
            ),
          if (role == "medecin")
            DrawerListTile(
              title: "Rendez-vous",
              svgSrc: "assets/icons/rendezvous.svg",
              press: () => {
                context.read<MyMenuController>().changePage(8),
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
                  title: Text(
                    "  ${context.watch<MyData>().currentUser?.prenom ?? '-'} ${context.watch<MyData>().currentUser?.nom ?? ''}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    role,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // deconnxion button
              InkWell(
                onTap: () async {
                  if (navigatorKey.currentContext != null) {
                    navigatorKey.currentContext!.showLoader();
                  }

                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  await authService.logout();

                  Navigator.pushReplacementNamed(context, '/LoginPage')
                      .then((_) {
                    if (navigatorKey.currentContext != null) {
                      navigatorKey.currentContext!.hideLoader();
                    }
                  });
                },

                // onTap: () async {
                //   if (navigatorKey.currentContext != null) {
                //     navigatorKey.currentContext!.showLoader();
                //   }
                //   final prefs = await SharedPreferences.getInstance();
                //   await prefs.clear();

                //   Navigator.pushReplacementNamed(context, '/login').then((_) {
                //     if (navigatorKey.currentContext != null) {
                //       navigatorKey.currentContext!.hideLoader();
                //     }
                //   });
                // },
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
          const SizedBox(
            height: 10,
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
