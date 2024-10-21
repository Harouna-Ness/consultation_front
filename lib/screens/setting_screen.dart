import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/customTable.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/direction_service.dart';
import 'package:medstory/service/statut_patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<Direction> directions = [];
  List<Sitedetravail> sitesDeTravails = [];
  List<Statut> statuts = [];
  List<StatutPatient> statutPatients = [];
  List<TypeDeConsultation> typesDeConsultations = [];
  List<MotifDeConsultation> motifDeConsultations = [];
  List<Analyse> analyses = [];

  @override
  Widget build(BuildContext context) {
    directions = context.watch<MyData>().directions;
    sitesDeTravails = context.watch<MyData>().siteDetravails;
    statutPatients = context.watch<MyData>().statutPatients;
    typesDeConsultations = context.watch<MyData>().typeDeConsultations;
    motifDeConsultations = context.watch<MyData>().motifDeConsultations;
    analyses = context.watch<MyData>().analyses;
    // statuts = context.watch<MyData>().

    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          // patient section
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Patient"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Box(
            child: Column(
              children: [
                StatutSectionTile(statutPatients: statutPatients),
                const Divider(
                  color: Colors.grey,
                ),
                DirectionSectionTile(directions: directions),
                const Divider(
                  color: Colors.grey,
                ),
                SiteSectionTile(sitesDeTravails: sitesDeTravails),
              ],
            ),
          ),

          const SizedBox(
            height: defaultPadding,
          ),

          // Consultation section
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Consultation"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Box(
            child: Column(
              children: [
                TypeSectionTile(typesDeConsultations: typesDeConsultations),
                const Divider(
                  color: Colors.grey,
                ),
                MotifSectionTile(motifDeConsultations: motifDeConsultations),
                const Divider(
                  color: Colors.grey,
                ),
                AnalyseSectionTile(analyses: analyses),
              ],
            ),
          ),

          const SizedBox(
            height: defaultPadding,
          ),

          // Rendez-vous section
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Rendez-vous"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Box(
            child: Column(
              children: [
                ExpansionTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  title: const Text("Statut"),
                  children: [
                    for (int index = 0; index < statuts.length; index++)
                      ListTile(
                        title: Text(statuts[index].libelle),
                      ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Ajouter",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypeSectionTile extends StatelessWidget {
  const TypeSectionTile({
    super.key,
    required this.typesDeConsultations,
  });

  final List<TypeDeConsultation> typesDeConsultations;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Type de consultation"),
      children: [
        for (int index = 0; index < typesDeConsultations.length; index++)
          ListTile(
            title: Text(typesDeConsultations[index].libelle),
          ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class MotifSectionTile extends StatelessWidget {
  const MotifSectionTile({
    super.key,
    required this.motifDeConsultations,
  });

  final List<MotifDeConsultation> motifDeConsultations;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Motif de consultation"),
      children: [
        for (int index = 0; index < motifDeConsultations.length; index++)
          ListTile(
            title: Text(motifDeConsultations[index].motif!),
          ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class AnalyseSectionTile extends StatelessWidget {
  const AnalyseSectionTile({
    super.key,
    required this.analyses,
  });

  final List<Analyse> analyses;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Analyse"),
      children: [
        for (int index = 0; index < analyses.length; index++)
          ListTile(
            title: Text(analyses[index].libelle!),
          ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class SiteSectionTile extends StatelessWidget {
  const SiteSectionTile({
    super.key,
    required this.sitesDeTravails,
  });

  final List<Sitedetravail> sitesDeTravails;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Site de travail"),
      children: [
        for (int index = 0; index < sitesDeTravails.length; index++)
          ListTile(
            title: Text(sitesDeTravails[index].nom),
          ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class DirectionSectionTile extends StatelessWidget {
  const DirectionSectionTile({
    super.key,
    required this.directions,
  });

  final List<Direction> directions;

  @override
  Widget build(BuildContext context) {
    final directionService = DirectionService();
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Direction"),
      children: [
        for (int index = 0; index < directions.length; index++)
          ListTile(
            title: Text(directions[index].nom),
          ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Direction direction = Direction(id: 0, nom: "test ajout 5");
                  directionService.createDirection(direction);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class StatutSectionTile extends StatefulWidget {
  const StatutSectionTile({
    super.key,
    required this.statutPatients,
  });

  final List<StatutPatient> statutPatients;

  @override
  State<StatutSectionTile> createState() => _StatutSectionTileState();
}

class _StatutSectionTileState extends State<StatutSectionTile> {
  TextEditingController statutController = TextEditingController();
  bool showForm = false;
  final statutPatientService = StatutPatientService();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Statut"),
      children: [
        for (int index = 0; index < widget.statutPatients.length; index++)
          ListTile(
            title: Text(widget.statutPatients[index].libelle),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                    ),
                  ),
                ],
              ),
            ),
          ),
        !showForm
            ? Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Ajouter",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            : Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(label: Text("Statut")),
                      controller: statutController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();
                      
                      if (statutController.text.isNotEmpty) {
                        print(
                            "object::::: voici le statut: ${statutController.text}");
                            StatutPatient statutPatient = StatutPatient(id: 0, libelle: statutController.text,);
                        
                        try {
                          await statutPatientService.createStatutPatient(statutPatient).then((onValue){
                          context.hideLoader();
                          context.showSuccess("Enregistrer");
                        });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez saisir le statut !");
                      }

                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Enregistrer",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(onPressed: (){
                    statutController.clear();
                    setState(() {
                      showForm = false;
                    });
                  }, style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Annuler",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}
