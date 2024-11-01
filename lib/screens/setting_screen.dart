import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/analyse.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/models/type_de_consultation.dart';
import 'package:medstory/service/analyse_service.dart';
import 'package:medstory/service/direction_service.dart';
import 'package:medstory/service/motif_de_consultation_service.dart';
import 'package:medstory/service/site_de_travail_service.dart';
import 'package:medstory/service/statut_patient_service.dart';
import 'package:medstory/service/statut_service.dart';
import 'package:medstory/service/type_consultation_service.dart.dart';
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
    statuts = context.watch<MyData>().statuts;

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
                StatutRdvTile(
                  statuts: statuts,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatutRdvTile extends StatefulWidget {
  const StatutRdvTile({
    super.key,
    required this.statuts,
  });

  final List<Statut> statuts;

  @override
  State<StatutRdvTile> createState() => _StatutRdvTileState();
}

class _StatutRdvTileState extends State<StatutRdvTile> {
  TextEditingController statutController = TextEditingController();
  bool showForm = false;
  final statutService = StatutService();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Statut"),
      children: [
        for (int index = 0; index < widget.statuts.length; index++)
          ListTile(
            title: Text(widget.statuts[index].libelle),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController statutController =
                              TextEditingController(
                            text: widget.statuts[index].libelle,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier le statut', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Statut du rendez-vous',
                                      controller: statutController,
                                      // On save fonction
                                      onSave: () async {
                                        if (statutController.text.isNotEmpty) {
                                          context.showLoader();

                                          Statut statut = Statut(
                                            id: widget.statuts[index].id,
                                            libelle: statutController.text,
                                          );

                                          await statutService
                                              .updateStatut(statut)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchStatut();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Statut modifié !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir le statut !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await statutService
                          .deleteStatut(widget.statuts[index].id)
                          .then((onValue) {
                        context.read<MyData>().fetchStatut();
                        context.hideLoader();
                        context.showSuccess("Statut supprimé");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(
                          label: Text("Statut du rendez-vous")),
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
                        Statut statut =
                            Statut(id: 0, libelle: statutController.text);

                        try {
                          await statutService
                              .createStatut(statut)
                              .then((onValue) {
                            context.read<MyData>().fetchStatut();
                            statutController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      statutController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}

class TypeSectionTile extends StatefulWidget {
  const TypeSectionTile({
    super.key,
    required this.typesDeConsultations,
  });

  final List<TypeDeConsultation> typesDeConsultations;

  @override
  State<TypeSectionTile> createState() => _TypeSectionTileState();
}

class _TypeSectionTileState extends State<TypeSectionTile> {
  TextEditingController typeController = TextEditingController();
  bool showForm = false;
  final typeService = TypeConsultationService();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Type de consultation"),
      children: [
        for (int index = 0; index < widget.typesDeConsultations.length; index++)
          ListTile(
            title: Text(widget.typesDeConsultations[index].libelle),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController typeController =
                              TextEditingController(
                            text: widget.typesDeConsultations[index].libelle,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier le type de consultaion', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Nom du site',
                                      controller: typeController,
                                      // On save fonction
                                      onSave: () async {
                                        if (typeController.text.isNotEmpty) {
                                          context.showLoader();

                                          TypeDeConsultation type =
                                              TypeDeConsultation(
                                            id: widget
                                                .typesDeConsultations[index].id,
                                            libelle: typeController.text,
                                          );

                                          await typeService
                                              .updateTypeDeConsultation(type)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchTypeDeConsultation();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Type de consultation modifié !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir le type de consultation !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await typeService
                          .deleteTypeDeConsultation(
                              widget.typesDeConsultations[index].id)
                          .then((onValue) {
                        context.read<MyData>().fetchTypeDeConsultation();
                        context.hideLoader();
                        context.showSuccess("Type supprimé");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(label: Text("Type")),
                      controller: typeController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();

                      if (typeController.text.isNotEmpty) {
                        TypeDeConsultation type = TypeDeConsultation(
                            id: 0, libelle: typeController.text);

                        try {
                          await typeService
                              .createTypeDeConsultation(type)
                              .then((onValue) {
                            context.read<MyData>().fetchTypeDeConsultation();
                            typeController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      typeController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}

class MotifSectionTile extends StatefulWidget {
  const MotifSectionTile({
    super.key,
    required this.motifDeConsultations,
  });

  final List<MotifDeConsultation> motifDeConsultations;

  @override
  State<MotifSectionTile> createState() => _MotifSectionTileState();
}

class _MotifSectionTileState extends State<MotifSectionTile> {
  TextEditingController motifController = TextEditingController();
  bool showForm = false;
  final motifService = MotifDeConsultationService();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Motif de consultation"),
      children: [
        for (int index = 0; index < widget.motifDeConsultations.length; index++)
          ListTile(
            title: Text(widget.motifDeConsultations[index].motif!),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController motifController =
                              TextEditingController(
                            text: widget.motifDeConsultations[index].motif,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier le motif de consultaion', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Motif',
                                      controller: motifController,
                                      // On save fonction
                                      onSave: () async {
                                        if (motifController.text.isNotEmpty) {
                                          context.showLoader();

                                          MotifDeConsultation
                                              motifDeConsultation =
                                              MotifDeConsultation(
                                            id: widget
                                                .motifDeConsultations[index].id,
                                            motif: motifController.text,
                                          );

                                          await motifService
                                              .updateMotifDeConsultation(
                                                  motifDeConsultation)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchMotifDeConsultion();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Motif de consultation modifié !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir le type de consultation !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await motifService
                          .deleteMotifDeConsultation(
                              widget.motifDeConsultations[index].id!)
                          .then((onValue) {
                        context.read<MyData>().fetchMotifDeConsultion();
                        context.hideLoader();
                        context.showSuccess("Motif supprimé");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(label: Text("Motif")),
                      controller: motifController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();

                      if (motifController.text.isNotEmpty) {
                        MotifDeConsultation motif = MotifDeConsultation(
                            id: 0, motif: motifController.text);

                        try {
                          await motifService
                              .createMotifDeConsultation(motif)
                              .then((onValue) {
                            context.read<MyData>().fetchMotifDeConsultion();
                            motifController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      motifController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}

class AnalyseSectionTile extends StatefulWidget {
  const AnalyseSectionTile({
    super.key,
    required this.analyses,
  });

  final List<Analyse> analyses;

  @override
  State<AnalyseSectionTile> createState() => _AnalyseSectionTileState();
}

class _AnalyseSectionTileState extends State<AnalyseSectionTile> {
  TextEditingController analyseController = TextEditingController();
  bool showForm = false;
  final analyseService = AnalyseService();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Analyse"),
      children: [
        for (int index = 0; index < widget.analyses.length; index++)
          ListTile(
            title: Text(widget.analyses[index].libelle!),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController analyseController =
                              TextEditingController(
                            text: widget.analyses[index].libelle,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier l\'analyse', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Nom de l\'analyse',
                                      controller: analyseController,
                                      // On save fonction
                                      onSave: () async {
                                        if (analyseController.text.isNotEmpty) {
                                          context.showLoader();

                                          Analyse analyse = Analyse(
                                            id: widget.analyses[index].id,
                                            libelle: analyseController.text,
                                          );

                                          await analyseService
                                              .updateAnalyse(analyse)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchAnalyse();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Motif de consultation modifié !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir le type de consultation !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await analyseService
                          .deleteAnalyse(widget.analyses[index].id!)
                          .then((onValue) {
                        context.read<MyData>().fetchAnalyse();
                        context.hideLoader();
                        context.showSuccess("Analyse supprimée");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(
                          label: Text("Nom de l'analyse")),
                      controller: analyseController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();

                      if (analyseController.text.isNotEmpty) {
                        Analyse analyse =
                            Analyse(id: 0, libelle: analyseController.text);

                        try {
                          await analyseService
                              .createAnalyse(analyse)
                              .then((onValue) {
                            context.read<MyData>().fetchAnalyse();
                            analyseController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      analyseController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}

class SiteSectionTile extends StatefulWidget {
  const SiteSectionTile({
    super.key,
    required this.sitesDeTravails,
  });

  final List<Sitedetravail> sitesDeTravails;

  @override
  State<SiteSectionTile> createState() => _SiteSectionTileState();
}

class _SiteSectionTileState extends State<SiteSectionTile> {
  TextEditingController siteController = TextEditingController();
  bool showForm = false;
  final sitedeTravailService = SiteDeTravailService();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Site de travail"),
      children: [
        for (int index = 0; index < widget.sitesDeTravails.length; index++)
          ListTile(
            title: Text(widget.sitesDeTravails[index].nom),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController siteController =
                              TextEditingController(
                            text: widget.sitesDeTravails[index].nom,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier le site de travail', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Nom du site',
                                      controller: siteController,
                                      // On save fonction
                                      onSave: () async {
                                        if (siteController.text.isNotEmpty) {
                                          context.showLoader();

                                          Sitedetravail site = Sitedetravail(
                                            id: widget
                                                .sitesDeTravails[index].id,
                                            nom: siteController.text,
                                          );

                                          await sitedeTravailService
                                              .updateSitedetravail(site)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchSiteDeTraivails();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context
                                                .showSuccess("Site modifié !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir un statut !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await sitedeTravailService
                          .deleteSitedetravail(widget.sitesDeTravails[index].id)
                          .then((onValue) {
                        context.read<MyData>().fetchSiteDeTraivails();
                        context.hideLoader();
                        context.showSuccess("Site supprimé");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(
                          label: Text("Nom du site de travail")),
                      controller: siteController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();

                      if (siteController.text.isNotEmpty) {
                        Sitedetravail site =
                            Sitedetravail(id: 0, nom: siteController.text);

                        try {
                          await sitedeTravailService
                              .createSitedetravail(site)
                              .then((onValue) {
                            context.read<MyData>().fetchSiteDeTraivails();
                            siteController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      siteController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
      ],
    );
  }
}

class DirectionSectionTile extends StatefulWidget {
  const DirectionSectionTile({
    super.key,
    required this.directions,
  });

  final List<Direction> directions;

  @override
  State<DirectionSectionTile> createState() => _DirectionSectionTileState();
}

class _DirectionSectionTileState extends State<DirectionSectionTile> {
  TextEditingController directionController = TextEditingController();
  bool showForm = false;
  final directionService = DirectionService();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none,
      ),
      title: const Text("Direction"),
      children: [
        for (int index = 0; index < widget.directions.length; index++)
          ListTile(
            title: Text(widget.directions[index].nom),
            trailing: SizedBox(
              width: 95,
              child: Row(
                children: [
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController directionController =
                              TextEditingController(
                            text: widget.directions[index].nom,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier la direction', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Nom de la direction',
                                      controller: directionController,
                                      // On save fonction
                                      onSave: () async {
                                        if (directionController
                                            .text.isNotEmpty) {
                                          context.showLoader();

                                          Direction direction = Direction(
                                              id: widget.directions[index].id,
                                              nom: directionController.text);

                                          await directionService
                                              .updateDirection(direction)
                                              .then((onValue) {
                                            context
                                                .read<MyData>()
                                                .fetchDirections();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Direction modifiée !");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir un statut !");
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await directionService
                          .deleteDirection(widget.directions[index].id)
                          .then((onValue) {
                        context.read<MyData>().fetchDirections();
                        context.hideLoader();
                        context.showSuccess("Direction supprimée");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
                      decoration: const InputDecoration(
                          label: Text("Nom de la direction")),
                      controller: directionController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.showLoader();

                      if (directionController.text.isNotEmpty) {
                        Direction direction =
                            Direction(id: 0, nom: directionController.text);

                        try {
                          await directionService
                              .createDirection(direction)
                              .then((onValue) {
                            context.read<MyData>().fetchDirections();
                            directionController.clear();
                            context.hideLoader();
                            context.showSuccess("Enregistrer !");
                          });
                        } catch (e) {
                          context.hideLoader();
                          context.showError(e.toString());
                        }
                      } else {
                        context.hideLoader();
                        context.showSnackError("Veuillez remplir le champ !");
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
                  ElevatedButton(
                    onPressed: () {
                      directionController.clear();
                      setState(() {
                        showForm = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                  const SizedBox(
                    width: 16,
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
                  // Edit button
                  IconButton(
                    onPressed: () {
                      // Dialog for edit form
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController statutController =
                              TextEditingController(
                            text: widget.statutPatients[index].libelle,
                          );

                          return Dialog(
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Modifier le statut', // Title for edit form
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomFormRow(
                                      // CustomForm widget
                                      labelText: 'Statut',
                                      controller: statutController,
                                      // On save fonction
                                      onSave: () async {
                                        if (statutController.text.isNotEmpty) {
                                          context.showLoader();

                                          StatutPatient statutPatient =
                                              StatutPatient(
                                            id: widget.statutPatients[index].id,
                                            libelle: statutController.text,
                                          );

                                          await statutPatientService
                                              .updateStatutPatient(
                                                  statutPatient)
                                              .then((onValue) {
                                            statutController.clear();
                                            context
                                                .read<MyData>()
                                                .fetchStatutPatient();
                                            context.hideLoader();
                                            Navigator.of(context).pop();
                                            context.showSuccess(
                                                "Statut mis à jour");
                                          }).catchError((e) {
                                            context.hideLoader();
                                            context.showError(
                                                "Erreur lors de la mise à jour : $e");
                                          });
                                        } else {
                                          context.showSnackError(
                                              "Veuillez saisir un statut !");
                                        }
                                      },
                                      onCancel: () {
                                        statutController.clear();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/edit.svg",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    // Delete button
                    onPressed: () async {
                      context.showLoader();

                      await statutPatientService
                          .deleteStatutPatient(widget.statutPatients[index].id)
                          .then((onValue) {
                        context.read<MyData>().fetchStatutPatient();
                        context.hideLoader();
                        context.showSuccess("Statut supprimé");
                      }).catchError((e) {
                        context.hideLoader();
                        context.showError("Erreur lors de la suppression : $e");
                      });
                    },
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
            : CustomFormRow(
                labelText: "Statut",
                controller: statutController,
                onSave: () async {
                  context.showLoader();

                  if (statutController.text.isNotEmpty) {
                    StatutPatient statutPatient = StatutPatient(
                      id: 0,
                      libelle: statutController.text,
                    );

                    try {
                      await statutPatientService
                          .createStatutPatient(statutPatient)
                          .then((onValue) {
                        context.read<MyData>().fetchStatutPatient();
                        context.hideLoader();
                        statutController.clear();
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
                onCancel: () {
                  statutController.clear();
                  setState(() {
                    showForm = false;
                  });
                },
              ),
      ],
    );
  }
}

class CustomFormRow extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String saveButtonText;
  final String cancelButtonText;
  final Color saveButtonColor;
  final Color cancelButtonColor;

  const CustomFormRow({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.saveButtonText = "Enregistrer",
    this.cancelButtonText = "Annuler",
    this.saveButtonColor = primaryColor,
    this.cancelButtonColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: labelText),
            controller: controller,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: saveButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            saveButtonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: cancelButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            cancelButtonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
