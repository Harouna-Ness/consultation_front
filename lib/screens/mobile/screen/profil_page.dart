import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/utilisateur.dart';
import 'package:medstory/screens/mobile/screen/login_moble.dart';
import 'package:medstory/screens/mobile/screen/main_page.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Utilisateur? _currentUser;
  @override
  Widget build(BuildContext context) {
    _currentUser = context.watch<MyData>().currentUser;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: _currentUser!.profileImage != null
                  ? NetworkImage(_currentUser!.profileImage!)
                  : null,
              child: _currentUser!.profileImage == null
                  ? SvgPicture.asset(
                      "assets/icons/person_icon.svg",
                      color: Colors.white,
                      width: 48,
                      height: 48,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${_currentUser!.prenom} ${_currentUser!.nom}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentUser!.role.libelle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),
          ProfileField(
            label: 'Email',
            value: _currentUser!.email,
          ),
          const SizedBox(height: 8),
          ProfileField(
            label: 'Téléphone',
            value: _currentUser!.telephone,
          ),
          const SizedBox(height: 8),
          ProfileField(
            label: 'Adresse',
            value: _currentUser!.adresse ?? '-',
          ),
          const SizedBox(height: 8),
          ProfileField(
            label: 'Sexe',
            value: _currentUser!.sexe,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginMoble()), // Remplacez par votre page spécifique
                      (Route<dynamic> route) =>
                          false, // Supprime toutes les routes précédentes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Se déconnecter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer()
          // const SizedBox(height: 20,)
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
