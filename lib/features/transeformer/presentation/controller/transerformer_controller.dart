import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoadRow {
  TextEditingController loadAmpsController = TextEditingController();
  TextEditingController qtyController      = TextEditingController(text: '1');
  bool isContinuous = false;

  void dispose() {
    loadAmpsController.dispose();
    qtyController.dispose();
  }
}

class TransformerController extends GetxController {

  String selectedPhase = 'single';

  final TextEditingController secVoltageController = TextEditingController();

  List<LoadRow> loadRows = [LoadRow()];

  bool   hasResult      = false;
  String calculatedLoad = '';
  String requiredKva    = '';
  String standardSize   = '';

  // ── Standard kVA sizes (Roadmap Section 5.1 + extended) ───
  // Exact Kotlin list + industry standard larger sizes
  static const List<double> standardKvaSizes = [
    1.0, 3.0, 5.0, 7.5, 10.0, 15.0, 25.0, 30.0, 37.5,
    45.0, 50.0, 75.0, 112.5, 150.0, 225.0, 300.0, 500.0,
    // Extended standard sizes
    750.0, 1000.0, 1500.0, 2000.0, 2500.0,
  ];

  // ── Phase setter ──────────────────────────────────────────
  void setPhase(String phase) {
    selectedPhase = phase;
    hasResult     = false;
    update();
  }

  // ── Add / Remove rows ─────────────────────────────────────
  void addLoadRow() {
    loadRows.add(LoadRow());
    update();
  }

  void removeLoadRow(int index) {
    if (loadRows.length > 1) {
      loadRows[index].dispose();
      loadRows.removeAt(index);
      hasResult = false;
      update();
    }
  }

  void toggleContinuous(int index) {
    loadRows[index].isContinuous = !loadRows[index].isContinuous;
    hasResult = false;
    update();
  }

  void calculate() {
    // Step 2: Collect voltage (Section 7: must be > 0)
    final double v =
        double.tryParse(secVoltageController.text.trim()) ?? 0.0;

    // if (v <= 0) {
    //   Get.snackbar(
    //     'Error', 'Please enter Secondary Voltage',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    // Steps 3–6: Collect loads, apply multiplier, sum
    // Section 7: blank/invalid = zero, qty < 0 not permitted
    double totalCalculatedAmps = 0.0;

    for (final row in loadRows) {
      final double a =
          double.tryParse(row.loadAmpsController.text.trim()) ?? 0.0;

      // Section 7: quantities less than zero not permitted
      final double qRaw =
          double.tryParse(row.qtyController.text.trim()) ?? 0.0;
      final double q = qRaw < 0 ? 0.0 : qRaw;

      // Section 2: continuous multiplier
      final double multiplier = row.isContinuous ? 1.25 : 1.0;

      // Section 2.2: Adjusted Load Amps = Amps × Multiplier × Qty
      totalCalculatedAmps += (a * multiplier * q);
    }

    // Step 7: Calculate kVA based on phase
    final double kva = selectedPhase == 'three'
        ? (totalCalculatedAmps * v * 1.732) / 1000.0  // Section 4.2
        : (totalCalculatedAmps * v) / 1000.0;          // Section 4.1

    // Steps 8–9: Find next standard size >= kVA (Section 5.2)
    final double? suggested =
    standardKvaSizes.firstWhereOrNull((s) => s >= kva);

    // Step 10: Display results
    calculatedLoad = '${totalCalculatedAmps.toStringAsFixed(1)} A';
    requiredKva    = '${kva.toStringAsFixed(2)} kVA';

    // Section 5.3: oversize condition
    standardSize = suggested != null
        ? '$suggested kVA'
        : 'Larger than ${standardKvaSizes.last.toInt()} kVA';

    hasResult = true;
    update();
  }

  // ── Dispose ───────────────────────────────────────────────
  @override
  void onClose() {
    secVoltageController.dispose();
    for (final row in loadRows) {
      row.dispose();
    }
    super.onClose();
  }
}