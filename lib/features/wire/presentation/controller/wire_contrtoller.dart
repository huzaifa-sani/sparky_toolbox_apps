import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmpacityResult {
  final String insulationBaseAmpacity;
  final String deratedAmpacity;
  final String terminalLimitedAmpacity;
  final String maxOCPDSize;
  final String ocpdDown;
  final String ocpdUp;
  final String note;

  AmpacityResult({
    required this.insulationBaseAmpacity,
    required this.deratedAmpacity,
    required this.terminalLimitedAmpacity,
    required this.maxOCPDSize,
    required this.ocpdDown,
    required this.ocpdUp,
    required this.note,
  });
}

const Map<String, Map<String, Map<String, double>>> customAmpacityTable = {
  'Copper': {
    '14 AWG':     {'60°C': 15,  '75°C': 20,  '90°C': 25},
    '12 AWG':     {'60°C': 20,  '75°C': 25,  '90°C': 30},
    '10 AWG':     {'60°C': 30,  '75°C': 35,  '90°C': 40},
    '8 AWG':      {'60°C': 40,  '75°C': 50,  '90°C': 55},
    '6 AWG':      {'60°C': 55,  '75°C': 65,  '90°C': 75},
    '4 AWG':      {'60°C': 70,  '75°C': 85,  '90°C': 95},
    '3 AWG':      {'60°C': 85,  '75°C': 100, '90°C': 115},
    '2 AWG':      {'60°C': 95,  '75°C': 115, '90°C': 130},
    '1 AWG':      {'60°C': 110, '75°C': 130, '90°C': 145},
    '1/0 AWG':    {'60°C': 125, '75°C': 150, '90°C': 170},
    '2/0 AWG':    {'60°C': 145, '75°C': 175, '90°C': 195},
    '3/0 AWG':    {'60°C': 165, '75°C': 200, '90°C': 225},
    '4/0 AWG':    {'60°C': 195, '75°C': 230, '90°C': 260},
    '250 kcmil':  {'60°C': 215, '75°C': 255, '90°C': 290},
    '300 kcmil':  {'60°C': 240, '75°C': 285, '90°C': 320},
    '350 kcmil':  {'60°C': 260, '75°C': 310, '90°C': 350},
    '400 kcmil':  {'60°C': 280, '75°C': 335, '90°C': 380},
    '500 kcmil':  {'60°C': 320, '75°C': 380, '90°C': 430},
    '600 kcmil':  {'60°C': 350, '75°C': 420, '90°C': 475},
    '700 kcmil':  {'60°C': 385, '75°C': 460, '90°C': 520},
    '750 kcmil':  {'60°C': 400, '75°C': 475, '90°C': 535},
    '800 kcmil':  {'60°C': 410, '75°C': 490, '90°C': 555},
    '900 kcmil':  {'60°C': 435, '75°C': 520, '90°C': 585},
    '1000 kcmil': {'60°C': 455, '75°C': 545, '90°C': 615},
  },
  'Aluminum': {
    '12 AWG':     {'60°C': 15,  '75°C': 20,  '90°C': 25},
    '10 AWG':     {'60°C': 25,  '75°C': 30,  '90°C': 35},
    '8 AWG':      {'60°C': 35,  '75°C': 40,  '90°C': 45},
    '6 AWG':      {'60°C': 40,  '75°C': 50,  '90°C': 55},
    '4 AWG':      {'60°C': 55,  '75°C': 65,  '90°C': 75},
    '3 AWG':      {'60°C': 65,  '75°C': 75,  '90°C': 85},
    '2 AWG':      {'60°C': 75,  '75°C': 90,  '90°C': 100},
    '1 AWG':      {'60°C': 85,  '75°C': 100, '90°C': 115},
    '1/0 AWG':    {'60°C': 100, '75°C': 120, '90°C': 135},
    '2/0 AWG':    {'60°C': 115, '75°C': 135, '90°C': 150},
    '3/0 AWG':    {'60°C': 130, '75°C': 155, '90°C': 175},
    '4/0 AWG':    {'60°C': 150, '75°C': 180, '90°C': 205},
    '250 kcmil':  {'60°C': 170, '75°C': 205, '90°C': 230},
    '300 kcmil':  {'60°C': 195, '75°C': 230, '90°C': 260},
    '350 kcmil':  {'60°C': 210, '75°C': 250, '90°C': 280},
    '400 kcmil':  {'60°C': 225, '75°C': 270, '90°C': 305},
    '500 kcmil':  {'60°C': 260, '75°C': 310, '90°C': 350},
    '600 kcmil':  {'60°C': 285, '75°C': 340, '90°C': 385},
    '700 kcmil':  {'60°C': 315, '75°C': 375, '90°C': 425},
    '750 kcmil':  {'60°C': 320, '75°C': 385, '90°C': 435},
    '800 kcmil':  {'60°C': 330, '75°C': 395, '90°C': 445},
    '900 kcmil':  {'60°C': 355, '75°C': 425, '90°C': 480},
    '1000 kcmil': {'60°C': 375, '75°C': 445, '90°C': 500},
  },
};

const Map<String, Map<String, double>> nec2404DLimits = {
  'Copper':   {'14 AWG': 15.0, '12 AWG': 20.0, '10 AWG': 30.0},
  'Aluminum': {'12 AWG': 20.0, '10 AWG': 25.0, '8 AWG':  40.0},
};

const Map<String, String> ambientTempDisplayMap = {
  '15°C (59°F) is 1.20':  '15°C (59°F)',
  '20°C (68°F) is 1.15':  '20°C (68°F)',
  '25°C (77°F) is 1.11':  '25°C (77°F)',
  '30°C (86°F) is 1.00':  '30°C (86°F)',
  '40°C (95°F) is 0.94':  '40°C (95°F)',
  '45°C (105°F) is 0.88': '45°C (105°F)',
  '50°C (113°F) is 0.82': '50°C (113°F)',
  '55°C (122°F) is 0.75': '55°C (122°F)',
  '60°C (131°F) is 0.67': '60°C (131°F)',
  '65°C (140°F) is 0.58': '65°C (140°F)',
  '70°C (149°F) is 0.47': '70°C (149°F)',
  '75°C (158°F) is 0.33': '75°C (158°F)',
};

const Map<String, String> conductorCountDisplayMap = {
  '1-3 is 1.00':   '1-3',
  '4-6 is 0.80':   '4-6',
  '7-9 is 0.70':   '7-9',
  '10-20 is 0.50': '10-20',
  '21-30 is 0.45': '21-30',
  '31-40 is 0.40': '31-40',
  '41+ is 0.35':   '41+',
};

const Map<String, double> ambientCorrectionFactors = {
  '15°C (59°F)':  1.20,
  '20°C (68°F)':  1.15,
  '25°C (77°F)':  1.11,
  '30°C (86°F)':  1.00,
  '40°C (95°F)':  0.94,
  '45°C (105°F)': 0.88,
  '50°C (113°F)': 0.82,
  '55°C (122°F)': 0.75,
  '60°C (131°F)': 0.67,
  '65°C (140°F)': 0.58,
  '70°C (149°F)': 0.47,
  '75°C (158°F)': 0.33,
};

const Map<String, double> bundleAdjustmentFactors = {
  '1-3':   1.00,
  '4-6':   0.80,
  '7-9':   0.70,
  '10-20': 0.50,
  '21-30': 0.45,
  '31-40': 0.40,
  '41+':   0.35,
};

int findNearestSizeDown(double target) {
  const sizes = [
    1, 3, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90,
    100, 110, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500, 600,
    700, 800, 900, 1000, 1200, 1600, 2000, 2500, 3000, 4000, 5000, 6000,
  ];
  int result = sizes.first;
  for (final s in sizes) {
    if (s <= target) result = s;
  }
  return result;
}

int findNearestSizeUp(double target) {
  const sizes = [
    1, 3, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90,
    100, 110, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500, 600,
    700, 800, 900, 1000, 1200, 1600, 2000, 2500, 3000, 4000, 5000, 6000,
  ];
  for (final s in sizes) {
    if (s >= target) return s;
  }
  return sizes.last;
}

class WireController extends GetxController {
  final finderController           = TextEditingController();
  final sizeController             = TextEditingController();
  final insulRatingController      = TextEditingController();
  final ambientTempController      = TextEditingController();
  final conductorCountController   = TextEditingController();
  final breakerTempLimitController = TextEditingController();

  final List<String> finder = ['Copper', 'Aluminum'];

  List<String> get size =>
      customAmpacityTable[_selectedMaterial]?.keys.toList() ?? [];

  final List<String> insulRating = ['60°C', '75°C', '90°C'];

  List<String> get ambientTempDisplay => ambientTempDisplayMap.values.toList();
  List<String> get conductorCountDisplay => conductorCountDisplayMap.values.toList();

  final List<String> breakerTempLimit = ['60°C', '75°C'];

  String _selectedMaterial   = 'Copper';
  String _selectedAmbientKey = '30°C (86°F)';
  String _selectedBundleKey  = '1-3';

  String? errorMessage;
  AmpacityResult? result;

  @override
  void onInit() {
    super.onInit();
    finderController.text           = 'Copper';
    sizeController.text             = customAmpacityTable['Copper']!.keys.first;
    insulRatingController.text      = '60°C';
    ambientTempController.text      = '30°C (86°F)';
    conductorCountController.text   = '1-3';
    breakerTempLimitController.text = '75°C';
  }

  void onChangeFinder(String? value) {
    if (value == null) return;
    _selectedMaterial     = value;
    finderController.text = value;
    sizeController.text   = customAmpacityTable[value]!.keys.first;
    errorMessage          = null;
    result                = null;
    update();
  }

  void onChangeSize(int index) {
    sizeController.text = size[index];
    result = null;
    update();
  }

  void onChangeInsulRating(int index) {
    insulRatingController.text = insulRating[index];
    result = null;
    update();
  }

  void onChangeAmbientTemp(int index) {

    final cleanText = ambientTempDisplayMap.values.elementAt(index);
    final rawKey    = ambientTempDisplayMap.keys.elementAt(index);
    ambientTempController.text = cleanText;
    _selectedAmbientKey        = ambientTempDisplayMap[rawKey]!;
    result = null;
    update();
  }

  void onChangeConductorCount(int index) {

    final cleanText = conductorCountDisplayMap.values.elementAt(index);
    final rawKey    = conductorCountDisplayMap.keys.elementAt(index);
    conductorCountController.text = cleanText;
    _selectedBundleKey            = conductorCountDisplayMap[rawKey]!;
    result = null;
    update();
  }

  void onChangeBreakerTempLimit(int index) {
    breakerTempLimitController.text = breakerTempLimit[index];
    result = null;
    update();
  }

  void calculate() {
    errorMessage = null;
    result       = null;

    final String material      = finderController.text;
    final String wireSize      = sizeController.text;
    final String selectedInsul = insulRatingController.text;
    final String breakerTemp   = breakerTempLimitController.text;

    if (material.isEmpty || wireSize.isEmpty || selectedInsul.isEmpty ||
        _selectedAmbientKey.isEmpty || _selectedBundleKey.isEmpty ||
        breakerTemp.isEmpty) {
      errorMessage = 'Please select all fields.';
      update();
      return;
    }

    final materialTable = customAmpacityTable[material];
    if (materialTable == null) {
      errorMessage = 'Invalid material selected.';
      update();
      return;
    }

    final wireSizeData = materialTable[wireSize];
    if (wireSizeData == null) {
      errorMessage = 'Wire size not available for $material.';
      update();
      return;
    }

    final double insulationBaseAmp = wireSizeData[selectedInsul] ?? 0.0;
    final double ambientFactor     = ambientCorrectionFactors[_selectedAmbientKey] ?? 1.0;
    final double bundleFactor      = bundleAdjustmentFactors[_selectedBundleKey]   ?? 1.0;
    final double fullyDeratedAmp   = insulationBaseAmp * ambientFactor * bundleFactor;
    final double roundedDeratedAmp = double.parse(fullyDeratedAmp.toStringAsFixed(1));

    final double terminalLimitAmp  = wireSizeData[breakerTemp] ?? 0.0;

    double finalAllowedAmp = roundedDeratedAmp < terminalLimitAmp
        ? roundedDeratedAmp
        : terminalLimitAmp;

    final double? smallConductorLimit = nec2404DLimits[material]?[wireSize];

    String limitMsg;

    if (smallConductorLimit != null && finalAllowedAmp > smallConductorLimit) {
      finalAllowedAmp = smallConductorLimit;
      limitMsg = 'Wire capped at '
          '(max ${smallConductorLimit.toInt()} A for $wireSize $material).';
    } else if (terminalLimitAmp < roundedDeratedAmp) {
      limitMsg = 'Limited by $breakerTemp equipment terminal rating '
          '(${terminalLimitAmp.toStringAsFixed(0)} A).';
    } else if (ambientFactor < 1.0 && bundleFactor == 1.0) {
      limitMsg = 'Limited by ambient temperature derating '
          '(factor $ambientFactor at $_selectedAmbientKey).';
    } else if (bundleFactor < 1.0 && ambientFactor == 1.0) {
      limitMsg = 'Limited by conductor bundling derating '
          '(factor $bundleFactor for $_selectedBundleKey conductors).';
    } else if (ambientFactor < 1.0 && bundleFactor < 1.0) {
      limitMsg = 'Limited by combined ambient ($ambientFactor) and '
          'bundling ($bundleFactor) derating factors.';
    } else {
      limitMsg = 'Note: Final ampacity is limited by the fully derated wire ampacity.';
    }

    final int ocpdDown = findNearestSizeDown(finalAllowedAmp);
    final int ocpdUp   = findNearestSizeUp(finalAllowedAmp);

    result = AmpacityResult(
      insulationBaseAmpacity:  '${insulationBaseAmp.toStringAsFixed(0)} A ($selectedInsul)',
      deratedAmpacity:         '${roundedDeratedAmp.toStringAsFixed(1)} A',
      terminalLimitedAmpacity: '${terminalLimitAmp.toStringAsFixed(0)} A ($breakerTemp)',
      maxOCPDSize:             '$ocpdDown A',
      ocpdDown:                '$ocpdDown A',
      ocpdUp:                  '$ocpdUp A',
      note:                    limitMsg,
    );
    update();
  }

  @override
  void onClose() {
    finderController.dispose();
    sizeController.dispose();
    insulRatingController.dispose();
    ambientTempController.dispose();
    conductorCountController.dispose();
    breakerTempLimitController.dispose();
    super.onClose();
  }
}