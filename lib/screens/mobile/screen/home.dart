import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medstory/constantes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset("assets/icons/MedStory.svg"),
        actions: [
          InkWell(
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: SvgPicture.asset(
                "assets/icons/Notification.svg",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          MedecinListPage(),
          const Center(
              child: Text('Page Dossier', style: TextStyle(fontSize: 24))),
          const Center(
              child: Text('Page Rendez-vous', style: TextStyle(fontSize: 24))),
          const Center(
              child: Text('Page Profif', style: TextStyle(fontSize: 24))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: tertiaryColor,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: _selectedIndex == 0
                ? SvgPicture.asset(
                    "assets/icons/homenav.svg",
                  )
                : SvgPicture.asset(
                    "assets/icons/homenav_.svg",
                  ),
          ),
          BottomNavigationBarItem(
            label: "Dossier",
            icon: _selectedIndex == 1
                ? SvgPicture.asset(
                    "assets/icons/Foldernav_.svg",
                  )
                : SvgPicture.asset(
                    "assets/icons/Foldernav.svg",
                  ),
          ),
          BottomNavigationBarItem(
            label: "Rendez-vous",
            icon: _selectedIndex == 2
                ? SvgPicture.asset(
                    "assets/icons/hournav_.svg",
                  )
                : SvgPicture.asset(
                    "assets/icons/hournav.svg",
                  ),
          ),
          BottomNavigationBarItem(
            label: "Profil",
            icon: _selectedIndex == 3
                ? SvgPicture.asset(
                    "assets/icons/profil_.svg",
                  )
                : SvgPicture.asset(
                    "assets/icons/person_icon.svg",
                  ),
          ),
        ],
      ),
    );
  }
}

class Medecinn {
  final String nom;
  final String prenom;
  final String specialite;
  final String imageAssetPath;

  Medecinn({
    required this.nom,
    required this.prenom,
    required this.specialite,
    required this.imageAssetPath,
  });
}

class MedecinListPage extends StatelessWidget {
  final List<Medecinn> medecins = [
    Medecinn(
      nom: "Kanté",
      prenom: "Noumouden",
      specialite: "Cardiologie",
      imageAssetPath: "assets/images/medecinA.png",
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinB.png",
    ),
    Medecinn(
      nom: "Diallo",
      prenom: "Hamidou",
      specialite: "Dermatologie",
      imageAssetPath: "assets/images/medecinC.png",
    ),
    // Ajoutez plus de médecins ici...
  ];

  MedecinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: medecins.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1, // Épaisseur du divider
        indent: 40, // Décalage depuis la gauche
        endIndent: 40, // Décalage depuis la droite
      ),
      itemBuilder: (context, index) {
        final medecin = medecins[index];
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
