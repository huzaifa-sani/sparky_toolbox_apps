import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolarController extends GetxController {
  int count = 1;

  final secondaryVoltageController = TextEditingController(text: '20');
  final peakController = TextEditingController(text: '5.5');
  final panelWattsController = TextEditingController(text: '400');

  List<TextEditingController> usageControllers = [TextEditingController()];
  List<TextEditingController> daysControllers = [TextEditingController()];

  // ── Results ────────────────────────────────────────────────
  String totalEnergy   = '';   // Average Daily Load e.g. "10.50 kWh"
  String panelCountOnly = '';  // "12"
  String requiredPanels = '';  // "12 Panels"
  String systemCapacity = '';  // "4.80 kW"
  bool   hasResult     = false;

  // ── Add new reading row ────────────────────────────────────
  void addConductors() {
    count++;
    usageControllers.add(TextEditingController());
    daysControllers.add(TextEditingController());
    update();
  }

  // ── Remove specific row by index (exact Kotlin logic) ──────
  void removeConductors(int index) {
    if (count <= 1) return;
    usageControllers[index].dispose();
    daysControllers[index].dispose();
    usageControllers.removeAt(index);
    daysControllers.removeAt(index);
    count--;
    hasResult = false;
    update();
  }


  void calculate() {
    final int    panelW    = int.tryParse(panelWattsController.text.trim()) ?? 400;
    final double peakHours = double.tryParse(peakController.text.trim())    ?? 5.5;
    final double lossPercent = double.tryParse(secondaryVoltageController.text.trim()) ?? 20.0;

    if (panelW <= 0) {
      Get.snackbar(
        'Error', 'Please enter Panel Watts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    double totalKwh  = 0.0;
    int    totalDays = 0;

    for (int i = 0; i < count; i++) {
      final kwh  = double.tryParse(usageControllers[i].text.trim()) ?? 0.0;
      final days = int.tryParse(daysControllers[i].text.trim())     ?? 0;
      totalKwh  += kwh;
      totalDays += days;
    }

    // if (totalDays <= 0) {
    //   Get.snackbar(
    //     'Error', 'Please enter Days values',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    final double avgDailyKwh = totalKwh / totalDays;

    final int panels = _calculateSolarRequirement(
      avgDailyKwh:  avgDailyKwh,
      panelWatts:   panelW,
      sunHours:     peakHours,
      lossPercent:  lossPercent,
    );

    // if (panels <= 0) {
    //   Get.snackbar(
    //     'Error', 'Please enter Usage (kWh) values',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    final double capacity = (panels * panelW).toDouble() / 1000.0;

    totalEnergy    = '${avgDailyKwh.toStringAsFixed(2)} kWh';
    panelCountOnly = '$panels';
    requiredPanels = panels == 1 ? '1 Panel' : '$panels Panels';
    systemCapacity = '${capacity.toStringAsFixed(2)} kW';
    hasResult      = true;
    update();
  }

  // ── Exact Kotlin calculateSolarRequirement function ────────
  int _calculateSolarRequirement({
    required double avgDailyKwh,
    required int    panelWatts,
    required double sunHours,
    required double lossPercent,
  }) {
    if (avgDailyKwh <= 0 || panelWatts <= 0 || sunHours <= 0) return 0;

    // 1. Adjust for system inefficiency
    final double requiredDailyGen = avgDailyKwh / (1 - (lossPercent / 100.0));

    // 2. What one panel produces per day (Watts × Hours ÷ 1000)
    final double panelYieldKwh = (panelWatts * sunHours) / 1000.0;

    // 3. Total panels needed (round up — exact Kotlin ceil)
    return (requiredDailyGen / panelYieldKwh).ceil();
  }

  @override
  void onClose() {
    secondaryVoltageController.dispose();
    peakController.dispose();
    panelWattsController.dispose();
    for (final c in usageControllers) c.dispose();
    for (final c in daysControllers)  c.dispose();
    super.onClose();
  }
}