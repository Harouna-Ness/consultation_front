import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/service/dio_client.dart';

class TimeSlotSelector extends StatefulWidget {
  final int medecinId;
  final DateTime selectedDate;
  final String heureDebut; // Par exemple "09:45"
  final String heureFin; // Par exemple "11:45"
  final int intervalMinutes; // Généralement 10 minutes
  final Function(TimeOfDay) onTimeSelected;

  const TimeSlotSelector({
    super.key,
    required this.medecinId,
    required this.selectedDate,
    required this.heureDebut,
    required this.heureFin,
    required this.intervalMinutes,
    required this.onTimeSelected,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  List<TimeOfDay> availableSlots = [];
  List<TimeOfDay> bookedSlots = [];
  TimeOfDay? _selectedSlot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  @override
  void didUpdateWidget(covariant TimeSlotSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si l'une des propriétés importantes change, recharger les créneaux
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.heureDebut != widget.heureDebut ||
        oldWidget.heureFin != widget.heureFin ||
        oldWidget.intervalMinutes != widget.intervalMinutes) {
      setState(() {
        isLoading = true;
        availableSlots.clear();
        bookedSlots.clear();
        _selectedSlot = null;
      });
      _loadTimeSlots();
    }
  }

  Future<void> _loadTimeSlots() async {
    // Convertir heureDebut et heureFin en TimeOfDay
    List<String> debutParts = widget.heureDebut.split(":");
    List<String> finParts = widget.heureFin.split(":");
    TimeOfDay workingStart = TimeOfDay(
        hour: int.parse(debutParts[0]), minute: int.parse(debutParts[1]));
    TimeOfDay workingEnd =
        TimeOfDay(hour: int.parse(finParts[0]), minute: int.parse(finParts[1]));

    // Récupérer les créneaux réservés via l'API
    try {
      final String dateStr =
          DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      final response = await DioClient.dio.get(
        'admin/creneaux-medecin-non-dispo',
        queryParameters: {
          'medecinId': widget.medecinId,
          'date': dateStr,
        },
      );

      // if (response.statusCode == 200) {
      //   List<dynamic> timesData = response.data;
      //   bookedSlots = timesData.map((timeStr) {
      //     List<String> parts = timeStr.toString().split(":");
      //     print(parts);
      //     return TimeOfDay(
      //       hour: int.parse(parts[0]),
      //       minute: int.parse(parts[1]),
      //     );
      //   }).toList();
      // }
      if (response.statusCode == 200) {
        List<dynamic> timesData = response.data;
        bookedSlots = timesData.map((timeData) {
          // timeData est supposé être une liste contenant deux éléments (heure et minute)
          List<dynamic> parts = timeData as List<dynamic>;
          int hour = parts[0] is int
              ? parts[0] as int
              : int.parse(parts[0].toString());
          int minute = parts[1] is int
              ? parts[1] as int
              : int.parse(parts[1].toString());
          print("Booked slot: hour=$hour, minute=$minute");
          return TimeOfDay(hour: hour, minute: minute);
        }).toList();
      }
    } catch (e) {
      print("Erreur lors de la récupération des créneaux réservés: $e");
    }

    // Générer tous les créneaux de 10 minutes entre workingStart et workingEnd
    availableSlots = generateAvailableTimeSlots(
      start: workingStart,
      end: workingEnd,
      intervalMinutes: widget.intervalMinutes,
    );

    // Filtrer les créneaux déjà réservés
    availableSlots = availableSlots.where((slot) {
      return !bookedSlots.any((booked) => _timeOfDayEquals(slot, booked));
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  String formatTimeOfDay24(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  List<TimeOfDay> generateAvailableTimeSlots({
    required TimeOfDay start,
    required TimeOfDay end,
    int intervalMinutes = 10,
  }) {
    List<TimeOfDay> slots = [];
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;
    for (int m = startMinutes; m <= endMinutes; m += intervalMinutes) {
      int hour = m ~/ 60;
      int minute = m % 60;
      slots.add(TimeOfDay(hour: hour, minute: minute));
    }
    return slots;
  }

  bool _timeOfDayEquals(TimeOfDay a, TimeOfDay b) {
    return a.hour == b.hour && a.minute == b.minute;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableSlots.map((slot) {
        final String label = formatTimeOfDay24(slot);
        final bool isSelected =
            _selectedSlot != null && _timeOfDayEquals(_selectedSlot!, slot);
        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          selected: isSelected,
          selectedColor: primaryColor,
          checkmarkColor: Colors.white,
          onSelected: (bool selected) {
            // Planifier l'appel à setState après le build courant pour éviter l'erreur
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedSlot = selected ? slot : null;
              });
              widget.onTimeSelected(slot);
            });
          },
        );
      }).toList(),
    );
  }
}
