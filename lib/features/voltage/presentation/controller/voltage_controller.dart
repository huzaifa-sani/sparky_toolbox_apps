import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoltageResult {
  final double voltageDrop;
  final double percentage;
  final double resistance;

  VoltageResult({
    required this.voltageDrop,
    required this.percentage,
    required this.resistance,
  });
}

class VoltageController extends GetxController {
  // ── Input Controllers ─────────────────────────────────────
  final supplyVoltageController = TextEditingController();
  final loadAmpsController      = TextEditingController();
  final distanceController      = TextEditingController();
  final sizeController          = TextEditingController(text: '12 AWG');

  // ── Options ───────────────────────────────────────────────
  final List<String> material = ['Copper', 'Aluminum'];
  final List<String> phase    = ['Single Phase', '3 Phase'];
  final List<String> conductorType = ['Solid', 'Stranded'];

  // ✅ FIXED: Added '3 AWG' (was missing)
  final List<String> size = [
    '14 AWG', '12 AWG', '10 AWG', '8 AWG', '6 AWG',
    '4 AWG',  '3 AWG',  '2 AWG',  '1 AWG',
    '1/0 AWG', '2/0 AWG', '3/0 AWG', '4/0 AWG',
    '250 kcmil', '300 kcmil', '350 kcmil', '400 kcmil',
    '500 kcmil', '600 kcmil', '700 kcmil', '750 kcmil',
    '800 kcmil', '900 kcmil', '1000 kcmil',
  ];

  // ── State ─────────────────────────────────────────────────
  String selectPhase     = 'Single Phase';
  String selectConductor = 'Solid';
  String selectMaterial  = 'Copper';

  VoltageResult? result;
  String? errorMessage;

  // ── Is current size stranded-only? (Kotlin isStrandedOnly) ─
  // #6 AWG and larger → Solid not available in NEC Table 8
  bool get isStrandedOnly {
    final s = sizeController.text;
    if (s.contains('kcmil')) return true;
    // sizes where only stranded exists: 6 AWG and larger
    const strandedOnly = [
      '6 AWG', '4 AWG', '3 AWG', '2 AWG', '1 AWG',
      '1/0 AWG', '2/0 AWG', '3/0 AWG', '4/0 AWG',
    ];
    return strandedOnly.contains(s);
  }

  // ── Radio Callbacks ───────────────────────────────────────
  void onChangePhase(dynamic value) {
    selectPhase = value.toString();
    result = null;
    update();
  }

  void onChangeConductor(dynamic value) {
    selectConductor = value.toString();
    result = null;
    update();
  }

  void onChangeMaterial(dynamic value) {
    selectMaterial = value.toString();
    result = null;
    update();
  }

  void onChangeSize(int index) {
    sizeController.text = size[index];
    // Auto-force Stranded for #6 AWG and larger (exact Kotlin logic)
    if (isStrandedOnly) selectConductor = 'Stranded';
    result = null;
    update();
  }

  // ══════════════════════════════════════════════════════════
  //  CALCULATE — exact Kotlin VoltageDropCalculator logic
  // ══════════════════════════════════════════════════════════
  void calculate() {
    errorMessage = null;
    result       = null;

    final double? supplyV  = double.tryParse(supplyVoltageController.text.trim());
    final double? amps     = double.tryParse(loadAmpsController.text.trim());
    final double? distance = double.tryParse(distanceController.text.trim());

    if (supplyV == null || amps == null || distance == null) {
      errorMessage = 'Please fill in all fields with valid numbers.';
      update();
      return;
    }

    if (supplyV <= 0 || amps <= 0 || distance <= 0) {
      errorMessage = 'All values must be greater than zero.';
      update();
      return;
    }

    final String wireSize = sizeController.text;
    // If size is stranded-only, fallback to Stranded even if Solid selected
    final bool useStranded =
    isStrandedOnly ? true : selectConductor == 'Stranded';

    final double? R = _getResistance(
      wireSize: wireSize,
      material: selectMaterial,
      stranded: useStranded,
    );

    if (R == null) {
      errorMessage = 'Resistance value not found for selected wire.';
      update();
      return;
    }

    // ── Exact Kotlin formula ──────────────────────────────
    // VD = (phaseFactor × R × I × L) / 1000
    // R in Ω/kft, L in feet → divide by 1000
    final double phaseFactor =
    selectPhase == '3 Phase' ? 1.732 : 2.0;
    final double voltageDrop = (phaseFactor * R * amps * distance) / 1000.0;
    final double percentage  = (voltageDrop / supplyV) * 100.0;

    result = VoltageResult(
      voltageDrop: voltageDrop,
      percentage:  percentage,
      resistance:  R,
    );
    update();
  }

  // ══════════════════════════════════════════════════════════
  //  NEC CHAPTER 9 TABLE 8 — RESISTANCE (Ω/kft) at 75°C
  //  Exact Kotlin table8Data values
  //  Structure: size → { 'Solid': (Cu, Al), 'Stranded': (Cu, Al) }
  // ══════════════════════════════════════════════════════════
  double? _getResistance({
    required String wireSize,
    required String material,
    required bool   stranded,
  }) {
    // Map: wireSize → [CuSolid, CuStranded, AlSolid, AlStranded]
    // Sizes #6 and larger only have Stranded in NEC Table 8
    // For those, Solid column = Stranded column (fallback)
    const Map<String, List<double>> table8 = {
      // ── Small sizes (both Solid & Stranded available) ──
      '14 AWG':    [3.07,   3.14,   5.06,   5.17  ],
      '12 AWG':    [1.93,   1.98,   3.18,   3.25  ],
      '10 AWG':    [1.21,   1.24,   2.00,   2.04  ],
      '8 AWG':     [0.764,  0.778,  1.26,   1.28  ],
      // ── #6 AWG and larger: Stranded only in NEC Table 8 ──
      // Solid index = Stranded index (same value, fallback)
      '6 AWG':     [0.491,  0.491,  0.808,  0.808 ],
      '4 AWG':     [0.308,  0.308,  0.508,  0.508 ],
      '3 AWG':     [0.245,  0.245,  0.403,  0.403 ],
      '2 AWG':     [0.194,  0.194,  0.319,  0.319 ],
      '1 AWG':     [0.154,  0.154,  0.253,  0.253 ],
      '1/0 AWG':   [0.122,  0.122,  0.201,  0.201 ],
      '2/0 AWG':   [0.0967, 0.0967, 0.159,  0.159 ],
      '3/0 AWG':   [0.0766, 0.0766, 0.126,  0.126 ],
      '4/0 AWG':   [0.0608, 0.0608, 0.100,  0.100 ],
      '250 kcmil': [0.0515, 0.0515, 0.0847, 0.0847],
      '300 kcmil': [0.0429, 0.0429, 0.0707, 0.0707],
      '350 kcmil': [0.0367, 0.0367, 0.0605, 0.0605],
      '400 kcmil': [0.0321, 0.0321, 0.0529, 0.0529],
      '500 kcmil': [0.0258, 0.0258, 0.0424, 0.0424],
      '600 kcmil': [0.0214, 0.0214, 0.0353, 0.0353],
      '700 kcmil': [0.0184, 0.0184, 0.0303, 0.0303],
      '750 kcmil': [0.0171, 0.0171, 0.0282, 0.0282],
      '800 kcmil': [0.0161, 0.0161, 0.0265, 0.0265],
      '900 kcmil': [0.0143, 0.0143, 0.0235, 0.0235],
      '1000 kcmil':[0.0129, 0.0129, 0.0212, 0.0212],
    };

    final List<double>? row = table8[wireSize];
    if (row == null) return null;

    // Index: CuSolid=0, CuStranded=1, AlSolid=2, AlStranded=3
    final bool isCopper = material == 'Copper';
    final int idx = isCopper
        ? (stranded ? 1 : 0)
        : (stranded ? 3 : 2);

    return row[idx];
  }

  // ── Dispose ───────────────────────────────────────────────
  @override
  void onClose() {
    supplyVoltageController.dispose();
    loadAmpsController.dispose();
    distanceController.dispose();
    sizeController.dispose();
    super.onClose();
  }
}