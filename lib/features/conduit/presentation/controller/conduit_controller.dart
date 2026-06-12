import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ══════════════════════════════════════════════════════════════
//  CONDUCTOR ENTRY MODEL
// ══════════════════════════════════════════════════════════════
class ConductorEntry {
  final TextEditingController insulationController;
  final TextEditingController sizeController;
  final TextEditingController qtyController;

  ConductorEntry()
      : insulationController = TextEditingController(text: 'THHN/THWN-2'),
        sizeController       = TextEditingController(text: '12 AWG'),
        qtyController        = TextEditingController(text: '1');

  void dispose() {
    insulationController.dispose();
    sizeController.dispose();
    qtyController.dispose();
  }
}

// ══════════════════════════════════════════════════════════════
//  RESULT MODEL — includes maxAllowedArea (Roadmap Section 7)
// ══════════════════════════════════════════════════════════════
class ConduitResult {
  final double fillPercent;
  final double totalWireArea;
  final double conduitArea;
  final double maxAllowedArea;   // conduitArea × fillLimit (new)
  final double fillLimitPercent; // 53, 31, or 40 (new)
  final bool   exceedsLimit;

  ConduitResult({
    required this.fillPercent,
    required this.totalWireArea,
    required this.conduitArea,
    required this.maxAllowedArea,
    required this.fillLimitPercent,
    required this.exceedsLimit,
  });
}

// ══════════════════════════════════════════════════════════════
//  NEC CHAPTER 9 TABLE 4 — CONDUIT 100% AREA (in²)
//  Exact Kotlin CUSTOM_CONDUIT_AREA_TABLE
// ══════════════════════════════════════════════════════════════
const Map<String, Map<String, double>> customConduitAreaTable = {
  'EMT': {
    '1/2 in': 0.304, '3/4 in': 0.533, '1 in': 0.864,
    '1 1/4 in': 1.496, '1 1/2 in': 2.036, '2 in': 3.356,
    '2 1/2 in': 5.585, '3 in': 8.846, '3 1/2 in': 11.545, '4 in': 14.753,
  },
  'RMC': {
    '1/2 in': 0.314, '3/4 in': 0.549, '1 in': 0.887,
    '1 1/4 in': 1.526, '1 1/2 in': 2.071, '2 in': 3.408,
    '2 1/2 in': 4.866, '3 in': 7.499, '3 1/2 in': 10.010, '4 in': 12.882,
  },
  'IMC': {
    '1/2 in': 0.342, '3/4 in': 0.586, '1 in': 0.959,
    '1 1/4 in': 1.647, '1 1/2 in': 2.225, '2 in': 3.630,
    '2 1/2 in': 5.135, '3 in': 7.922, '3 1/2 in': 10.584, '4 in': 13.631,
  },
  'PVC Sch 40': {
    '1/2 in': 0.285, '3/4 in': 0.508, '1 in': 0.832,
    '1 1/4 in': 1.453, '1 1/2 in': 1.986, '2 in': 3.291,
    '2 1/2 in': 4.695, '3 in': 7.268, '3 1/2 in': 9.737, '4 in': 12.554,
  },
  'PVC Sch 80': {
    '1/2 in': 0.217, '3/4 in': 0.409, '1 in': 0.688,
    '1 1/4 in': 1.237, '1 1/2 in': 1.711, '2 in': 2.874,
    '2 1/2 in': 4.119, '3 in': 6.442, '3 1/2 in': 8.688, '4 in': 11.258,
  },
  'FMC': {
    '1/2 in': 0.317, '3/4 in': 0.533, '1 in': 0.817,
    '1 1/4 in': 1.277, '1 1/2 in': 1.858, '2 in': 3.269,
    '2 1/2 in': 4.909, '3 in': 7.069, '3 1/2 in': 9.621, '4 in': 12.566,
  },
  'LFMC': {
    '1/2 in': 0.314, '3/4 in': 0.541, '1 in': 0.873,
    '1 1/4 in': 1.528, '1 1/2 in': 1.981, '2 in': 3.246,
    '2 1/2 in': 4.881, '3 in': 7.475, '3 1/2 in': 9.731, '4 in': 12.692,
  },
  'LFNC-A': {
    '3/8 in': 0.192, '1/2 in': 0.312, '3/4 in': 0.535, '1 in': 0.854,
    '1 1/4 in': 1.502, '1 1/2 in': 2.018, '2 in': 3.343,
  },
  'LFNC-B': {
    '3/8 in': 0.192, '1/2 in': 0.314, '3/4 in': 0.541, '1 in': 0.873,
    '1 1/4 in': 1.528, '1 1/2 in': 1.981, '2 in': 3.246,
  },
};

// ══════════════════════════════════════════════════════════════
//  NEC CHAPTER 9 TABLE 5 — WIRE AREA (in²)
//  Exact Kotlin CUSTOM_WIRE_AREA_TABLE
// ══════════════════════════════════════════════════════════════
const Map<String, Map<String, double>> customWireAreaTable = {
  'THHN/THWN-2': {
    '14 AWG': 0.0097,  '12 AWG': 0.0133,  '10 AWG': 0.0211,
    '8 AWG':  0.0366,  '6 AWG':  0.0507,  '4 AWG':  0.0824,
    '3 AWG':  0.0973,  '2 AWG':  0.1158,  '1 AWG':  0.1562,
    '1/0 AWG': 0.1855, '2/0 AWG': 0.2223, '3/0 AWG': 0.2679,
    '4/0 AWG': 0.3237, '250 kcmil': 0.3970, '300 kcmil': 0.4608,
    '350 kcmil': 0.5242, '400 kcmil': 0.5863, '500 kcmil': 0.7073,
    '600 kcmil': 0.8676, '700 kcmil': 0.9887, '750 kcmil': 1.0496,
    '800 kcmil': 1.1085, '900 kcmil': 1.2311, '1000 kcmil': 1.3478,
  },
  'XHHW-2': {
    '14 AWG': 0.0139,  '12 AWG': 0.0181,  '10 AWG': 0.0243,
    '8 AWG':  0.0437,  '6 AWG':  0.0590,  '4 AWG':  0.0814,
    '3 AWG':  0.0962,  '2 AWG':  0.1146,  '1 AWG':  0.1534,
    '1/0 AWG': 0.1825, '2/0 AWG': 0.2190, '3/0 AWG': 0.2642,
    '4/0 AWG': 0.3197, '250 kcmil': 0.3904, '300 kcmil': 0.4536,
    '350 kcmil': 0.5166, '400 kcmil': 0.5782, '500 kcmil': 0.6984,
    '600 kcmil': 0.8709, '700 kcmil': 0.9923, '750 kcmil': 1.0532,
    '800 kcmil': 1.1122, '900 kcmil': 1.2351, '1000 kcmil': 1.3519,
  },
  'RHH/RHW-2': {
    '14 AWG': 0.0293,  '12 AWG': 0.0353,  '10 AWG': 0.0437,
    '8 AWG':  0.0835,  '6 AWG':  0.1041,  '4 AWG':  0.1333,
    '3 AWG':  0.1521,  '2 AWG':  0.1750,  '1 AWG':  0.2660,
    '1/0 AWG': 0.3039, '2/0 AWG': 0.3505, '3/0 AWG': 0.4072,
    '4/0 AWG': 0.4754, '250 kcmil': 0.6291, '300 kcmil': 0.7088,
    '350 kcmil': 0.7870, '400 kcmil': 0.8626, '500 kcmil': 1.0082,
    '600 kcmil': 1.2135, '700 kcmil': 1.3561, '750 kcmil': 1.4272,
    '800 kcmil': 1.4957, '900 kcmil': 1.6377, '1000 kcmil': 1.7719,
  },
};


class ConduitController extends GetxController {
  List<ConductorEntry> conductors = [ConductorEntry()];
  int get count => conductors.length;

  // ── Dropdown Options ──────────────────────────────────────
  final List<String> conduitType = customConduitAreaTable.keys.toList();

  // Dynamic size list based on selected type
  List<String> get conduitSize =>
      customConduitAreaTable[conduitTypeController.text]?.keys.toList() ?? [];

  final List<String> insulation = customWireAreaTable.keys.toList();
  final List<String> size =
  customWireAreaTable['THHN/THWN-2']!.keys.toList();

  // ── Controllers ───────────────────────────────────────────
  final conduitTypeController = TextEditingController(text: 'EMT');
  final conduitSizeController = TextEditingController(text: '3/4 in');

  // ── State ─────────────────────────────────────────────────
  ConduitResult? result;
  String? errorMessage;

  // ── Dropdown Callbacks ────────────────────────────────────
  void onChangeConduitType(int index) {
    conduitTypeController.text = conduitType[index];
    // Reset to first available size for new type
    final sizes =
    customConduitAreaTable[conduitType[index]]?.keys.toList();
    if (sizes != null && sizes.isNotEmpty) {
      conduitSizeController.text = sizes.first;
    }
    result = null;
    update();
  }

  void onChangeConduitSize(int index) {
    conduitSizeController.text = conduitSize[index];
    result = null;
    update();
  }

  // ── Conductor Management ──────────────────────────────────
  void addConductors() {
    conductors.add(ConductorEntry());
    update();
  }

  void removeConductors(int index) {
    if (conductors.length <= 1) return;
    conductors[index].dispose();
    conductors.removeAt(index);
    result = null;
    update();
  }

  // ══════════════════════════════════════════════════════════
  //  CALCULATE — Roadmap Section 10 exact flow
  // ══════════════════════════════════════════════════════════
  void calculate() {
    errorMessage = null;
    result       = null;

    final String type    = conduitTypeController.text;
    final String sizeStr = conduitSizeController.text;

    // Step 3: Get conduit area (Section 8: must not be zero)
    final double? conduitArea =
    customConduitAreaTable[type]?[sizeStr];
    if (conduitArea == null || conduitArea == 0) {
      errorMessage = 'Conduit type/size combination not found.';
      update();
      return;
    }

    // Steps 4–8: Sum all conductor areas + qty
    double totalWireArea = 0.0;
    int    totalQty      = 0;

    for (final entry in conductors) {
      final String insul    = entry.insulationController.text;
      final String wireSize = entry.sizeController.text;
      final int    qty      =
          int.tryParse(entry.qtyController.text) ?? 0;

      // Section 8: qty must be > 0
      if (qty <= 0) {
        errorMessage =
        'Quantity must be greater than zero for all conductors.';
        update();
        return;
      }

      final double? wireArea = customWireAreaTable[insul]?[wireSize];
      if (wireArea == null) {
        errorMessage = 'Wire area not found for $wireSize ($insul).';
        update();
        return;
      }

      totalWireArea += wireArea * qty;
      totalQty      += qty;
    }

    // Section 8: total conductor area must not be zero
    if (totalWireArea == 0) {
      errorMessage = 'Total conductor area cannot be zero.';
      update();
      return;
    }

    // Step 12: NEC fill limit (Section 5 — exact Kotlin rule)
    final double fillLimitPercent = () {
      if (totalQty == 1) return 53.0;
      if (totalQty == 2) return 31.0;
      return 40.0;
    }();

    // Max allowed area = conduitArea × (limit / 100)
    final double maxAllowedArea =
        conduitArea * (fillLimitPercent / 100.0);

    // Step 11: Fill percentage
    final double fillPercent = (totalWireArea / conduitArea) * 100.0;

    // Step 13: Compliance check (Section 6)
    final bool exceeds = fillPercent > fillLimitPercent;

    result = ConduitResult(
      fillPercent:       fillPercent,
      totalWireArea:     totalWireArea,
      conduitArea:       conduitArea,
      maxAllowedArea:    maxAllowedArea,
      fillLimitPercent:  fillLimitPercent,
      exceedsLimit:      exceeds,
    );
    update();
  }

  // ── Dispose ───────────────────────────────────────────────
  @override
  void onClose() {
    conduitTypeController.dispose();
    conduitSizeController.dispose();
    for (final c in conductors) {
      c.dispose();
    }
    super.onClose();
  }
}