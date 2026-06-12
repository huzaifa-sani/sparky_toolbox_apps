import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


const Map<String, Map<String, double>> motorDataMaster = {
  // ── Single-Phase (NEC 430.248) ────────────────────────────
  '1/6-1P': {'1-Phase 115V': 4.4,  '1-Phase 200V': 2.5,  '1-Phase 208V': 2.4,  '1-Phase 230V': 2.2},
  '1/4-1P': {'1-Phase 115V': 5.8,  '1-Phase 200V': 3.3,  '1-Phase 208V': 3.2,  '1-Phase 230V': 2.9},
  '1/3-1P': {'1-Phase 115V': 7.2,  '1-Phase 200V': 4.1,  '1-Phase 208V': 4.0,  '1-Phase 230V': 3.6},
  '1/2-1P': {'1-Phase 115V': 9.8,  '1-Phase 200V': 5.6,  '1-Phase 208V': 5.4,  '1-Phase 230V': 4.9},
  '3/4-1P': {'1-Phase 115V': 13.8, '1-Phase 200V': 7.9,  '1-Phase 208V': 7.6,  '1-Phase 230V': 6.9},
  '1-1P':   {'1-Phase 115V': 16.0, '1-Phase 200V': 9.2,  '1-Phase 208V': 8.8,  '1-Phase 230V': 8.0},
  '1-1/2-1P': {'1-Phase 115V': 20.0, '1-Phase 200V': 11.5, '1-Phase 208V': 11.0, '1-Phase 230V': 10.0},
  '2-1P':   {'1-Phase 115V': 24.0, '1-Phase 200V': 13.8, '1-Phase 208V': 13.2, '1-Phase 230V': 12.0},
  '3-1P':   {'1-Phase 115V': 34.0, '1-Phase 200V': 19.6, '1-Phase 208V': 18.7, '1-Phase 230V': 17.0},
  '5-1P':   {'1-Phase 115V': 56.0, '1-Phase 200V': 32.2, '1-Phase 208V': 30.8, '1-Phase 230V': 28.0},
  '7-1/2-1P': {'1-Phase 115V': 80.0, '1-Phase 200V': 46.0, '1-Phase 208V': 44.0, '1-Phase 230V': 40.0},
  '10-1P':  {'1-Phase 115V': 100.0,'1-Phase 200V': 57.5, '1-Phase 208V': 55.0, '1-Phase 230V': 50.0},

  // ── Two-Phase 4-Wire (NEC 430.249) ───────────────────────
  '1/2-2P': {'115V': 4.0,  '230V': 2.0,  '460V': 1.0,  '575V': 0.8},
  '3/4-2P': {'115V': 4.8,  '230V': 2.4,  '460V': 1.2,  '575V': 1.0},
  '1-2P':   {'115V': 6.4,  '230V': 3.2,  '460V': 1.6,  '575V': 1.3},
  '1-1/2-2P': {'115V': 9.0, '230V': 4.5, '460V': 2.3,  '575V': 1.8},
  '2-2P':   {'115V': 11.8, '230V': 5.9,  '460V': 3.0,  '575V': 2.4},
  '3-2P':   {'230V': 8.3,  '460V': 4.2,  '575V': 3.3},
  '5-2P':   {'230V': 13.2, '460V': 6.6,  '575V': 5.3},
  '7-1/2-2P': {'230V': 19.0,'460V': 9.0, '575V': 8.0},
  '10-2P':  {'230V': 24.0, '460V': 12.0, '575V': 10.0},
  '15-2P':  {'230V': 36.0, '460V': 18.0, '575V': 14.0},
  '20-2P':  {'230V': 47.0, '460V': 23.0, '575V': 19.0},
  '25-2P':  {'230V': 59.0, '460V': 29.0, '575V': 24.0},
  '30-2P':  {'230V': 69.0, '460V': 35.0, '575V': 28.0},
  '40-2P':  {'230V': 90.0, '460V': 45.0, '575V': 36.0},
  '50-2P':  {'230V': 113.0,'460V': 56.0, '575V': 45.0},
  '60-2P':  {'230V': 133.0,'460V': 67.0, '575V': 53.0, '2300V': 14.0},
  '75-2P':  {'230V': 166.0,'460V': 83.0, '575V': 66.0, '2300V': 18.0},
  '100-2P': {'230V': 218.0,'460V': 109.0,'575V': 87.0, '2300V': 23.0},
  '125-2P': {'230V': 270.0,'460V': 135.0,'575V': 108.0,'2300V': 28.0},
  '150-2P': {'230V': 312.0,'460V': 156.0,'575V': 125.0,'2300V': 32.0},
  '200-2P': {'230V': 416.0,'460V': 208.0,'575V': 167.0,'2300V': 43.0},

  // ── Three-Phase (NEC 430.250) ─────────────────────────────
  '1/2-3P': {'3-Phase 208V': 2.4,  '3-Phase 230V': 2.2,  '3-Phase 460V': 1.1,  '3-Phase 575V': 0.9},
  '3/4-3P': {'3-Phase 208V': 3.5,  '3-Phase 230V': 3.2,  '3-Phase 460V': 1.6,  '3-Phase 575V': 1.3},
  '1-3P':   {'3-Phase 208V': 4.6,  '3-Phase 230V': 4.2,  '3-Phase 460V': 2.1,  '3-Phase 575V': 1.7},
  '1-1/2-3P': {'3-Phase 208V': 6.6,'3-Phase 230V': 6.0,  '3-Phase 460V': 3.0,  '3-Phase 575V': 2.4},
  '2-3P':   {'3-Phase 208V': 7.5,  '3-Phase 230V': 6.8,  '3-Phase 460V': 3.4,  '3-Phase 575V': 2.7},
  '3-3P':   {'3-Phase 208V': 10.6, '3-Phase 230V': 9.6,  '3-Phase 460V': 4.8,  '3-Phase 575V': 3.9},
  '5-3P':   {'3-Phase 208V': 16.7, '3-Phase 230V': 15.2, '3-Phase 460V': 7.6,  '3-Phase 575V': 6.1},
  '7-1/2-3P': {'3-Phase 208V': 24.2,'3-Phase 230V': 22.0,'3-Phase 460V': 11.0, '3-Phase 575V': 9.0},
  '10-3P':  {'3-Phase 208V': 30.8, '3-Phase 230V': 28.0, '3-Phase 460V': 14.0, '3-Phase 575V': 11.0},
  '15-3P':  {'3-Phase 208V': 46.2, '3-Phase 230V': 42.0, '3-Phase 460V': 21.0, '3-Phase 575V': 17.0},
  '20-3P':  {'3-Phase 208V': 59.4, '3-Phase 230V': 54.0, '3-Phase 460V': 27.0, '3-Phase 575V': 22.0},
  '25-3P':  {'3-Phase 208V': 74.8, '3-Phase 230V': 68.0, '3-Phase 460V': 34.0, '3-Phase 575V': 27.0},
  '30-3P':  {'3-Phase 208V': 88.0, '3-Phase 230V': 80.0, '3-Phase 460V': 40.0, '3-Phase 575V': 32.0},
  '40-3P':  {'3-Phase 208V': 114.0,'3-Phase 230V': 104.0,'3-Phase 460V': 52.0, '3-Phase 575V': 41.0},
  '50-3P':  {'3-Phase 208V': 143.0,'3-Phase 230V': 130.0,'3-Phase 460V': 65.0, '3-Phase 575V': 52.0},
  '60-3P':  {'3-Phase 208V': 169.0,'3-Phase 230V': 154.0,'3-Phase 460V': 77.0, '3-Phase 575V': 62.0},
  '75-3P':  {'3-Phase 208V': 211.0,'3-Phase 230V': 192.0,'3-Phase 460V': 96.0, '3-Phase 575V': 77.0},
  '100-3P': {'3-Phase 208V': 273.0,'3-Phase 230V': 248.0,'3-Phase 460V': 124.0,'3-Phase 575V': 99.0},
  '125-3P': {'3-Phase 208V': 343.0,'3-Phase 230V': 312.0,'3-Phase 460V': 156.0,'3-Phase 575V': 125.0},
  '150-3P': {'3-Phase 208V': 396.0,'3-Phase 230V': 360.0,'3-Phase 460V': 180.0,'3-Phase 575V': 144.0},
  '200-3P': {'3-Phase 208V': 528.0,'3-Phase 230V': 480.0,'3-Phase 460V': 240.0,'3-Phase 575V': 192.0},
  '250-3P': {'3-Phase 460V': 302.0,'3-Phase 575V': 242.0},
  '300-3P': {'3-Phase 460V': 361.0,'3-Phase 575V': 289.0},
  '350-3P': {'3-Phase 460V': 414.0,'3-Phase 575V': 336.0},
  '400-3P': {'3-Phase 460V': 477.0,'3-Phase 575V': 382.0},
  '450-3P': {'3-Phase 460V': 515.0,'3-Phase 575V': 412.0},
  '500-3P': {'3-Phase 460V': 590.0,'3-Phase 575V': 472.0},
};

// ══════════════════════════════════════════════════════════════
//  HELPER: motorFinalSorter
// ══════════════════════════════════════════════════════════════
double motorFinalSorter(String key) {
  final hpPart = key.contains('-')
      ? key.substring(0, key.lastIndexOf('-'))
      : key;
  try {
    if (hpPart.contains('/')) {
      final parts = hpPart.split('-');
      if (parts.length > 1) {
        final whole = double.parse(parts[0]);
        final frac  = parts[1].split('/');
        return whole + (double.parse(frac[0]) / double.parse(frac[1]));
      } else {
        final frac = hpPart.split('/');
        return double.parse(frac[0]) / double.parse(frac[1]);
      }
    } else {
      return double.parse(hpPart);
    }
  } catch (_) {
    return 0.0;
  }
}

// ══════════════════════════════════════════════════════════════
//  HELPER: getMotorWireSize  (NEC 310.16 @ 75°C Cu)
// ══════════════════════════════════════════════════════════════
String getMotorWireSize(double amps) {
  if (amps <= 20.0)  return '#14 AWG';
  if (amps <= 25.0)  return '#12 AWG';
  if (amps <= 35.0)  return '#10 AWG';
  if (amps <= 50.0)  return '#8 AWG';
  if (amps <= 65.0)  return '#6 AWG';
  if (amps <= 85.0)  return '#4 AWG';
  if (amps <= 100.0) return '#3 AWG';
  if (amps <= 115.0) return '#2 AWG';
  if (amps <= 130.0) return '#1 AWG';
  if (amps <= 150.0) return '#1/0 AWG';
  if (amps <= 175.0) return '#2/0 AWG';
  if (amps <= 200.0) return '#3/0 AWG';
  if (amps <= 230.0) return '#4/0 AWG';
  if (amps <= 255.0) return '250 kcmil';
  if (amps <= 285.0) return '300 kcmil';
  if (amps <= 310.0) return '350 kcmil';
  if (amps <= 335.0) return '400 kcmil';
  if (amps <= 380.0) return '500 kcmil';

  // Parallel logic >380A
  final options = [
    ('500 kcmil', 380.0), ('400 kcmil', 335.0), ('350 kcmil', 310.0),
    ('300 kcmil', 285.0), ('250 kcmil', 255.0), ('4/0 AWG',   230.0),
    ('3/0 AWG',   200.0), ('2/0 AWG',   175.0), ('1/0 AWG',   150.0),
  ];
  String bestName = '';
  int    minSets  = 999999;
  double lowestTotal = double.maxFinite;
  for (final opt in options) {
    final sets  = (amps / opt.$2).ceil();
    final total = sets * opt.$2;
    if (sets < minSets) {
      minSets = sets; lowestTotal = total; bestName = opt.$1;
    } else if (sets == minSets && total < lowestTotal) {
      lowestTotal = total; bestName = opt.$1;
    }
  }
  return '($minSets) $bestName';
}

// ══════════════════════════════════════════════════════════════
//  HELPER: getGroundingWireSize  (NEC Table 250.122)
// ══════════════════════════════════════════════════════════════
String getGroundingWireSize(int breakerAmps) {
  if (breakerAmps <= 15)   return '#14 AWG';
  if (breakerAmps <= 20)   return '#12 AWG';
  if (breakerAmps <= 60)   return '#10 AWG';
  if (breakerAmps <= 100)  return '#8 AWG';
  if (breakerAmps <= 200)  return '#6 AWG';
  if (breakerAmps <= 300)  return '#4 AWG';
  if (breakerAmps <= 400)  return '#3 AWG';
  if (breakerAmps <= 500)  return '#2 AWG';
  if (breakerAmps <= 600)  return '#1 AWG';
  if (breakerAmps <= 800)  return '1/0 AWG';
  if (breakerAmps <= 1000) return '2/0 AWG';
  if (breakerAmps <= 1200) return '3/0 AWG';
  if (breakerAmps <= 1600) return '4/0 AWG';
  if (breakerAmps <= 2000) return '250 kcmil';
  if (breakerAmps <= 2500) return '350 kcmil';
  if (breakerAmps <= 3000) return '400 kcmil';
  if (breakerAmps <= 4000) return '500 kcmil';
  if (breakerAmps <= 5000) return '700 kcmil';
  return '800 kcmil';
}

String getNextStandardBreakerSize(double amps) {

  const sizes = [
    1, 3, 6,7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100,
    110, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500, 600,
    700, 800, 900, 1000, 1200, 1600, 2000, 2500, 3000, 4000, 5000, 6000,
  ];

  if (amps > 6000) return '6000';

  final size = sizes.firstWhere((s) => s >= amps, orElse: () => 6000);

  return size.toString();

}

class MotorController extends GetxController {
  final List<String> phaseOptions = ['1-Phase', '2-Phase', '3-Phase'];
  String selectedPhase = '3-Phase';

  List<String> get filteredHpKeys {
    final suffix = _phaseSuffix();
    final keys = motorDataMaster.keys
        .where((k) => k.endsWith(suffix))
        .toList()
      ..sort((a, b) => motorFinalSorter(a).compareTo(motorFinalSorter(b)));
    return keys;
  }

  List<String> get hpDisplayList =>
      filteredHpKeys.map((k) => _hpKeyToDisplay(k)).toList();

  List<String> get voltageOptions {
    if (selectedHpKey.isEmpty) return [];
    return motorDataMaster[selectedHpKey]?.keys.toList() ?? [];
  }

  String selectedHpKey  = '';
  String selectedVoltage = '';

  // ── Result fields ─────────────────────────────────────────
  String phaseLabel   = '';
  String fullLoadAmps = '';
  String maxITBreaker = '';
  String maxTDFuse    = '';
  String minAmpacity  = '';
  String wireSize     = '';
  String egcBreaker   = '';
  String egcFuse      = '';
  bool   hasResult    = false;

  // ── Phase change ──────────────────────────────────────────
  void onPhaseChange(String phase) {
    selectedPhase   = phase;
    selectedHpKey   = '';
    selectedVoltage = '';
    hasResult       = false;
    update();
  }

  void onSelectHp(int index) {
    selectedHpKey   = filteredHpKeys[index];
    selectedVoltage = '';
    hasResult       = false;
    update();
  }

  void onSelectVoltage(int index) {
    selectedVoltage = voltageOptions[index];
    hasResult       = false;
    update();
  }


  String? errorMessage;

  void calculate() {
    errorMessage = null;

    if (selectedHpKey.isEmpty) {
      errorMessage = 'Please select Horsepower (HP).';
      hasResult = false;
      update();
      return;
    }

    if (selectedVoltage.isEmpty) {
      errorMessage = 'Please select Voltage.';
      hasResult = false;
      update();
      return;
    }

    final double? flc = motorDataMaster[selectedHpKey]?[selectedVoltage];
    if (flc == null) {
      errorMessage = 'No data found for selected HP and Voltage.';
      hasResult = false;
      update();
      return;
    }

    phaseLabel = switch (selectedPhase) {
      '1-Phase' => 'Single-Phase',
      '2-Phase' => 'Two-Phase',
      _         => 'Three-Phase',
    };

    fullLoadAmps = flc.toString();

    final breakerValRaw = getNextStandardBreakerSize(flc * 2.5);
    final fuseValRaw    = getNextStandardBreakerSize(flc * 1.75);

    final int breakerInt = int.tryParse(breakerValRaw) ?? 0;
    maxITBreaker = breakerInt < 15 ? 'N/A' : '$breakerValRaw A';
    maxTDFuse    = '$fuseValRaw A';

    final double wireTargetAmps = flc * 1.25;
    minAmpacity = wireTargetAmps.toStringAsFixed(2);
    wireSize    = getMotorWireSize(wireTargetAmps);

    final int fuseInt = int.tryParse(fuseValRaw) ?? 15;
    egcBreaker = maxITBreaker == 'N/A'
        ? 'N/A'
        : '${getGroundingWireSize(breakerInt)} Cu';
    egcFuse    = '${getGroundingWireSize(fuseInt)} Cu';

    hasResult = true;
    update();
  }
  String _hpKeyToDisplay(String key) {
    final hpPart = key.substring(0, key.lastIndexOf('-'));
    return '${hpPart.replaceAll('-', ' ')} HP';
  }

  String get selectedHpDisplay =>
      selectedHpKey.isEmpty ? '' : _hpKeyToDisplay(selectedHpKey);

  String _phaseSuffix() => switch (selectedPhase) {
    '1-Phase' => '-1P',
    '2-Phase' => '-2P',
    _         => '-3P',
  };
}