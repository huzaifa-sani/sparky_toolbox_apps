import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransformResult {
  final String primaryFLA;
  final String secondaryFLA;
  final String primaryOCPD;
  final String primaryFuse;
  final String secondaryOCPD;
  final String secondaryFuse;
  final String primaryWireSize;
  final String secondaryWireSize;
  final String primaryECG;
  final String secondaryECG;
  final String unifiedECG;
  final int    maxOCPD;
  final String equipmentNote;
  final String ruleNote;

  TransformResult({
    required this.primaryFLA,
    required this.secondaryFLA,
    required this.primaryOCPD,
    required this.primaryFuse,
    required this.secondaryOCPD,
    required this.secondaryFuse,
    required this.primaryWireSize,
    required this.secondaryWireSize,
    required this.primaryECG,
    required this.secondaryECG,
    required this.unifiedECG,
    required this.maxOCPD,
    required this.equipmentNote,
    required this.ruleNote,
  });
}

class TransformController extends GetxController {
  final kvaController              = TextEditingController();
  final primaryVoltageController   = TextEditingController();
  final secondaryVoltageController = TextEditingController();

  final List<String> phase = ['Single Phase', 'Three Phase'];
  String selectPhase       = 'Three Phase';

  final List<String> method = [
    'Primary Only Protection',
    'Primary + Secondary Protection',
  ];
  String selectMethod = 'Primary Only Protection';

  bool   isLoading           = false;
  String? errorMessage;
  TransformResult? result;
  String equipmentLimitLabel = '';

  // ✅ নতুন: limit store করার জন্য
  double _maxKvaLimit = double.infinity;

  // ✅ নতুন: kVA limit এর বেশি কিনা চেক করে
  bool get isOverLimit {
    final kva = double.tryParse(kvaController.text.trim()) ?? 0;
    return _maxKvaLimit.isFinite && kva > _maxKvaLimit;
  }

  static const List<int> _standardSizes = [
    1, 3, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100,
    110, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500, 600,
    700, 800, 900, 1000, 1200, 1600, 2000, 2500, 3000, 4000, 5000, 6000,
  ];

  @override
  void onInit() {
    super.onInit();

    // ✅ নতুন: kvaController listener যোগ করা হয়েছে
    kvaController.addListener(_updateEquipmentLimit);
    primaryVoltageController.addListener(_updateEquipmentLimit);
    secondaryVoltageController.addListener(_updateEquipmentLimit);

    _updateEquipmentLimit();
  }

  void onChangePhase(String? value) {
    if (value == null) return;
    selectPhase = value;
    result      = null;
    _updateEquipmentLimit();
    update();
  }

  void onChangeMethod(String? value) {
    if (value == null) return;
    selectMethod = value;
    result       = null;
    _updateEquipmentLimit();
    update();
  }

  void _updateEquipmentLimit() {
    final double pV = double.tryParse(primaryVoltageController.text) ?? 0.0;
    final double sV = double.tryParse(secondaryVoltageController.text) ?? 0.0;
    final double m  = selectPhase == 'Three Phase' ? 1.732 : 1.0;

    if (pV > 0 && sV > 0) {

      final double dynamicMax;

      if (selectMethod == 'Primary Only Protection') {
        dynamicMax = (6000.0 * pV * m) / 1250.0;
      } else {
        final kvaP = (6000.0 * pV * m) / 2500.0;
        final kvaS = (6000.0 * sV * m) / 1250.0;
        dynamicMax = kvaP < kvaS ? kvaP : kvaS;
      }

      _maxKvaLimit = dynamicMax;
      equipmentLimitLabel = 'Limit for selection: ${dynamicMax.toInt()} kVA';
    } else {
      _maxKvaLimit = double.infinity;
    }
    update();
  }

  Future<void> calculate() async {
    errorMessage = null;
    result       = null;

    final double? kva        = double.tryParse(kvaController.text.trim());
    final double? primaryV   = double.tryParse(primaryVoltageController.text.trim());
    final double? secondaryV = double.tryParse(secondaryVoltageController.text.trim());

    if (kva == null || primaryV == null || secondaryV == null) {
      errorMessage = 'Please fill in all fields with valid numbers.';
      update();
      return;
    }

    if (primaryV > 600 || secondaryV > 600) {
      errorMessage = 'Voltage must not exceed 600V.';
      update();
      return;
    }

    isLoading = true;
    update();

    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final double multiplier = selectPhase == 'Three Phase' ? 1.732 : 1.0;
      final double va = kva * 1000.0;

      final double pA = va / (primaryV   * multiplier);
      final double sA = va / (secondaryV * multiplier);

      final bool isPrimaryOnly = selectMethod == 'Primary Only Protection';

      String primaryOCPD, primaryFuse, primaryWire;
      String secondaryOCPD = '', secondaryFuse = '', secondaryWire = '';
      String primaryECG, secondaryECG = '';

      if (isPrimaryOnly) {

        final double pMultiplier;
        final bool   pCanRoundUp;

        if (pA < 2.0) {
          pMultiplier  = 3.00;
          pCanRoundUp  = false;
        } else if (pA < 9.0) {
          pMultiplier  = 1.67;
          pCanRoundUp  = false;
        } else {
          pMultiplier  = 1.25;
          pCanRoundUp  = true;
        }

        final int pBreakerRaw = _findBreaker(pA * pMultiplier, pCanRoundUp);
        primaryOCPD = (pBreakerRaw >= 15) ? '$pBreakerRaw A' : 'N/A';

        final int pFuseRaw = _findBreaker(pA * pMultiplier, pCanRoundUp);
        primaryFuse = '$pFuseRaw A';

        final double wireBase = pBreakerRaw.toDouble() > pFuseRaw.toDouble()
            ? pBreakerRaw.toDouble()
            : pFuseRaw.toDouble();
        primaryWire = _getTransformerWireSize(wireBase);

        final int ocpdForECG = pBreakerRaw >= 15 ? pBreakerRaw : pFuseRaw;
        primaryECG = '${_getGroundingWireSize(ocpdForECG)} Cu';

        final int maxOCPD = pBreakerRaw >= 15 ? pBreakerRaw : pFuseRaw;
        final String unifiedECG = _getGroundingWireSize(maxOCPD);

        final String ruleNote = pA < 2.0
            ? 'Primary FLA < 2A: Maximum 300% protection allowed. Rounding up NOT permitted.'
            : pA < 9.0
            ? 'Primary FLA < 9A: Limited to 167%. Rounding up NOT permitted.'
            : 'If the calculated OCPD does not match a standard size, the next higher standard size is chosen.';

        result = TransformResult(
          primaryFLA:        pA.toStringAsFixed(2),
          secondaryFLA:      sA.toStringAsFixed(2),
          primaryOCPD:       primaryOCPD,
          primaryFuse:       primaryFuse,
          secondaryOCPD:     '',
          secondaryFuse:     '',
          primaryWireSize:   primaryWire,
          secondaryWireSize: '',
          primaryECG:        primaryECG,
          secondaryECG:      '',
          unifiedECG:        unifiedECG,
          maxOCPD:           maxOCPD,
          equipmentNote:
          'Standard Inverse-Time breakers and Time-Delay fuses are recommended to handle transformer inrush.',
          ruleNote: ruleNote,
        );

      } else {

        final double pMultiplier = pA < 2.0 ? 3.00 : 2.50;
        final int pSizeRaw =
        _findBreaker(pA * pMultiplier, false).clamp(0, 6000);
        primaryOCPD = (pSizeRaw >= 15) ? '$pSizeRaw A' : 'N/A';
        primaryFuse = '$pSizeRaw A';
        primaryWire = _getTransformerWireSize(pSizeRaw.toDouble());
        primaryECG  = '${_getGroundingWireSize(pSizeRaw)} Cu';

        final double sMultiplier;
        final bool   sCanRoundUp;

        if (sA < 2.0) {
          sMultiplier  = 3.00;
          sCanRoundUp  = false;
        } else if (sA < 9.0) {
          sMultiplier  = 1.67;
          sCanRoundUp  = false;
        } else {
          sMultiplier  = 1.25;
          sCanRoundUp  = true;
        }

        final int sSizeRaw = _findBreaker(sA * sMultiplier, sCanRoundUp);
        secondaryOCPD = (sSizeRaw >= 15) ? '$sSizeRaw A' : 'N/A';
        secondaryFuse = '$sSizeRaw A';
        secondaryWire = _getTransformerWireSize(sSizeRaw.toDouble());
        secondaryECG  = '${_getGroundingWireSize(sSizeRaw)} Cu';

        final int    maxOCPD    = pSizeRaw > sSizeRaw ? pSizeRaw : sSizeRaw;
        final String unifiedECG = _getGroundingWireSize(maxOCPD);

        final String ruleNote = sA < 2.0
            ? 'Secondary FLA < 2A: Maximum 300% protection allowed (NEC 450.3). Rounding up NOT permitted.'
            : sA < 9.0
            ? 'Secondary FLA < 9A: Limited to 167% with NO rounding up permitted.'
            : 'Primary capped at 250% (Rounded Down). Secondary at 125% (Rounded Up).';

        result = TransformResult(
          primaryFLA:        pA.toStringAsFixed(2),
          secondaryFLA:      sA.toStringAsFixed(2),
          primaryOCPD:       primaryOCPD,
          primaryFuse:       primaryFuse,
          secondaryOCPD:     secondaryOCPD,
          secondaryFuse:     secondaryFuse,
          primaryWireSize:   primaryWire,
          secondaryWireSize: secondaryWire,
          primaryECG:        primaryECG,
          secondaryECG:      secondaryECG,
          unifiedECG:        unifiedECG,
          maxOCPD:           maxOCPD,
          equipmentNote:
          'Standard Inverse-Time breakers and Time-Delay fuses are recommended to handle transformer inrush.',
          ruleNote: ruleNote,
        );
      }
    } catch (e) {
      errorMessage = 'Calculation failed. Please check your inputs.';
    } finally {
      isLoading = false;
      update();
    }
  }

  int _findBreaker(double target, bool canRoundUp) {
    if (canRoundUp) {
      final s = _standardSizes.firstWhereOrNull((s) => s >= target);
      return (s ?? 6000).clamp(0, 6000);
    } else {
      int result = _standardSizes.first;
      for (final s in _standardSizes) {
        if (s <= target) result = s;
      }
      return result.clamp(0, 6000);
    }
  }

  String _getTransformerWireSize(double amps) {
    if (amps > 310.0 && amps <= 400.0) return '(2) 3/0 AWG';
    if (amps <= 380.0) {
      if (amps <= 15)  return '#14 AWG';
      if (amps <= 20)  return '#12 AWG';
      if (amps <= 30)  return '#10 AWG';
      if (amps <= 50)  return '#8 AWG';
      if (amps <= 65)  return '#6 AWG';
      if (amps <= 85)  return '#4 AWG';
      if (amps <= 100) return '#3 AWG';
      if (amps <= 115) return '#2 AWG';
      if (amps <= 130) return '#1 AWG';
      if (amps <= 150) return '#1/0 AWG';
      if (amps <= 175) return '#2/0 AWG';
      if (amps <= 200) return '#3/0 AWG';
      if (amps <= 230) return '#4/0 AWG';
      if (amps <= 255) return '250 kcmil';
      if (amps <= 285) return '300 kcmil';
      if (amps <= 310) return '350 kcmil';
      if (amps <= 335) return '400 kcmil';
      return '500 kcmil';
    }
    final options = [
      ('3/0 AWG',   200.0),
      ('4/0 AWG',   230.0),
      ('250 kcmil', 255.0),
      ('300 kcmil', 285.0),
      ('350 kcmil', 310.0),
      ('400 kcmil', 335.0),
      ('500 kcmil', 380.0),
    ];
    String bestName = '';
    int minSets = 999999;
    for (final opt in options) {
      final sets = (amps / opt.$2).ceil();
      if (sets < minSets) {
        minSets  = sets;
        bestName = opt.$1;
      }
    }
    return '($minSets) $bestName';
  }

  String _getGroundingWireSize(int breakerAmps) {
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

  @override
  void onClose() {
    // ✅ নতুন: kvaController listener remove করা হয়েছে
    kvaController.removeListener(_updateEquipmentLimit);
    primaryVoltageController.removeListener(_updateEquipmentLimit);
    secondaryVoltageController.removeListener(_updateEquipmentLimit);

    kvaController.dispose();
    primaryVoltageController.dispose();
    secondaryVoltageController.dispose();
    super.onClose();
  }
}