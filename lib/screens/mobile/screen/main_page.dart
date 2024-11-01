import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/screens/mobile/component/medecin_liste.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
        children: const [
          Home(),
          Center(child: Text('Page Dossier', style: TextStyle(fontSize: 24))),
          Center(
              child: Text('Page Rendez-vous', style: TextStyle(fontSize: 24))),
          Center(child: Text('Page Profif', style: TextStyle(fontSize: 24))),
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nos Médecins"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MedecinListPage()));
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(
                    color: tertiaryColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          MedecinListe(medecins: medecins, count: 3),
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
      body: MedecinListe(
        medecins: medecins,
        count: medecins.length,
      ),
    );
  }
}
