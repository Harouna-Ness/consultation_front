import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/empty_content.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/patient.dart';

class DossierPatient extends StatefulWidget {
  final Patient patient;
  final void Function() changeView;
  const DossierPatient(
      {super.key, required this.patient, required this.changeView});

  @override
  State<DossierPatient> createState() => _DossierPatientState();
}

class _DossierPatientState extends State<DossierPatient> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Box(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dossier Patient",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  // LOGIQUE POUR Fermer LE DOSSIER PATIENT
                  onPressed: widget.changeView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Fermer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            // Information personnelle
            const SizedBox(
              height: defaultPadding,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Prénom",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.patient.prenom,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nom",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.patient.nom,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            // allergie
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Allergie",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (widget.patient.dossierMedical != null &&
                                widget
                                    .patient.dossierMedical!.allergies!.isEmpty)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 240, 239, 239),
                                      height: 100,
                                      child: const Center(
                                        child: Text(
                                          "Pas de contenu !",
                                          style: TextStyle(
                                            color: tertiaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: widget.patient.dossierMedical != null
                                    ? widget.patient.dossierMedical!.allergies!
                                        .map(
                                          (allergie) => Column(
                                            children: [
                                              Text(
                                                " - ${allergie.nom}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList()
                                    : [],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            // Les antecedents
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // antecedent
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Antecedent",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (widget.patient.dossierMedical != null &&
                                widget.patient.dossierMedical!.antecedents!
                                    .isEmpty)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 240, 239, 239),
                                      height: 100,
                                      child: const Center(
                                        child: Text(
                                          "Pas de contenu !",
                                          style: TextStyle(
                                            color: tertiaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: widget.patient.dossierMedical != null
                                    ? widget
                                        .patient.dossierMedical!.antecedents!
                                        .map(
                                          (antecedent) => Column(
                                            children: [
                                              Text(
                                                "- ${antecedent.nomMaladie}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList()
                                    : [],
                              ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: (widget.patient.dossierMedical != null &&
                            widget.patient.dossierMedical!.antecedents!.isEmpty)
                        ? 0
                        : 100,
                  ),
                  // antecedent familial
                  (widget.patient.dossierMedical != null &&
                          widget.patient.dossierMedical!.antecedentFamiliaux!
                              .isEmpty)
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Antecedent familial",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: widget.patient.dossierMedical != null
                                  ? widget.patient.dossierMedical!
                                      .antecedentFamiliaux!
                                      .map(
                                        (antecedent) => Column(
                                          children: [
                                            Text(
                                              "- ${antecedent.nomMaladie}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList()
                                  : [],
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            // consultation
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.patient.dossierMedical != null &&
                          widget.patient.dossierMedical!.consultations!.isEmpty)
                      ? const SizedBox()
                      : const Text(
                          "Consultation",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    // carte consultation design
                    children: widget.patient.dossierMedical != null
                        ? widget.patient.dossierMedical!.consultations!
                            .map(
                              (consultation) => Container(
                                height: 170,
                                width: 140,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[400]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Fait par",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Dr ${consultation.medecin!.nom}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const Spacer(),
                                    Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/Report.svg",
                                        height: 65,
                                        width: 70,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Le ${consultation.creationDate!.day}/${consultation.creationDate!.month}/${consultation.creationDate!.year}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                        : [],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
