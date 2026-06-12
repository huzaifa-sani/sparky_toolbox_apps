import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DwellingController extends GetxController {

  int heatingUnitCount = 1;
  int motorLoadCount   = 1;
  int applianceCount   = 1;
  int acUnitCount      = 1;
  int evChargerCount   = 1;

  final areaController       = TextEditingController();
  final multiplierController = TextEditingController(text: '2');
  final appQtaController     = TextEditingController(text: '2');
  final laodQtaController    = TextEditingController(text: '1');
  final rangeQtaController   = TextEditingController(text: '1');
  final rangeVaController    = TextEditingController(text: '12000');
  final dryerQtyController   = TextEditingController(text: '1');
  final dryerVaController    = TextEditingController(text: '5000');
  final poolMotorController  = TextEditingController();

  List<TextEditingController> acUnitControllers      = [TextEditingController()];
  List<TextEditingController> heatingUnitControllers = [TextEditingController()];
  List<TextEditingController> motorLoadControllers   = [TextEditingController()];
  List<TextEditingController> evChargerControllers   = [TextEditingController()];
  List<TextEditingController> applianceControllers   = [TextEditingController()];

  double? resultAmpacity;
  double? totalVA;
  String  resultBreakdown = '';
  bool    showResult      = false;
  String? errorMessage;

  void addAcUnit() { acUnitCount++; acUnitControllers.add(TextEditingController()); update(); }
  void removeACUnits() { if (acUnitCount > 1) { acUnitCount--; acUnitControllers.removeLast().dispose(); update(); } }
  void addHeatingUnit() { heatingUnitCount++; heatingUnitControllers.add(TextEditingController()); update(); }
  void removeHeatingUnit() { if (heatingUnitCount > 1) { heatingUnitCount--; heatingUnitControllers.removeLast().dispose(); update(); } }
  void addMotorLoad() { motorLoadCount++; motorLoadControllers.add(TextEditingController()); update(); }
  void removeMotorLoad() { if (motorLoadCount > 1) { motorLoadCount--; motorLoadControllers.removeLast().dispose(); update(); } }
  void addEvCharger() { evChargerCount++; evChargerControllers.add(TextEditingController()); update(); }
  void removeEVUnits() { if (evChargerCount > 1) { evChargerCount--; evChargerControllers.removeLast().dispose(); update(); } }
  void addAppliance() { applianceCount++; applianceControllers.add(TextEditingController()); update(); }
  void removeAppliance() { if (applianceCount > 1) { applianceCount--; applianceControllers.removeLast().dispose(); update(); } }

  void resetAll() {
    areaController.clear();
    multiplierController.text = '2';
    appQtaController.text     = '2';
    laodQtaController.text    = '1';
    rangeQtaController.text   = '1';
    rangeVaController.text    = '12000';
    dryerQtyController.text   = '1';
    dryerVaController.text    = '5000';
    poolMotorController.clear();
    for (final c in [
      ...acUnitControllers, ...heatingUnitControllers,
      ...motorLoadControllers, ...evChargerControllers,
      ...applianceControllers
    ]) { c.dispose(); }
    acUnitCount = heatingUnitCount = motorLoadCount = evChargerCount = applianceCount = 1;
    acUnitControllers      = [TextEditingController()];
    heatingUnitControllers = [TextEditingController()];
    motorLoadControllers   = [TextEditingController()];
    evChargerControllers   = [TextEditingController()];
    applianceControllers   = [TextEditingController()];
    resultAmpacity = null; totalVA = null; resultBreakdown = ''; showResult = false;
    update();
  }

  // ✅ special character সরানোর helper
  String _sanitizeForPdf(String text) {
    return text
        .replaceAll('>=', '>=')
        .replaceAll('<=', '<=')
        .replaceAll('->', '->')
        .replaceAll('≥', '>=')
        .replaceAll('≤', '<=')
        .replaceAll('→', '->')
        .replaceAll('−', '-')
        .replaceAll('<', 'less than ')
        .replaceAll('>', 'more than ');
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal800,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Dwelling Load Calculation',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Standard Method',
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.teal100),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.teal400),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Load: ${totalVA?.toStringAsFixed(0) ?? "0"} VA',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Service Ampacity: ${resultAmpacity?.toStringAsFixed(1) ?? "0"} A',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal800,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Load Breakdown',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text(
                _sanitizeForPdf(resultBreakdown), // ✅ sanitize করা হচ্ছে
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 5),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                'Sparky Toolbox',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  double _calculateDryerDemand(int dCount, double dRatingVA) {
    if (dCount <= 0) return 0.0;
    final double baseDryerVA = dRatingVA > 5000.0 ? dRatingVA : 5000.0;
    final double totalConnected = baseDryerVA * dCount;
    double factor;
    if (dCount <= 2)       { factor = 1.00; }
    else if (dCount <= 5)  { factor = 0.80; }
    else if (dCount == 6)  { factor = 0.75; }
    else if (dCount == 7)  { factor = 0.65; }
    else if (dCount == 8)  { factor = 0.60; }
    else if (dCount == 9)  { factor = 0.55; }
    else if (dCount == 10) { factor = 0.50; }
    else if (dCount == 11) { factor = 0.47; }
    else if (dCount <= 23) { factor = (47.0 - (dCount - 11)) / 100.0; }
    else if (dCount <= 42) { factor = (35.0 - ((dCount - 23) * 0.5)) / 100.0; }
    else                   { factor = 0.25; }
    return totalConnected * factor;
  }

  double _calculateRangeDemand(int rCount, double rRatingVA) {
    if (rCount <= 0) return 0.0;
    final double kw = rRatingVA / 1000.0;

    if (kw < 3.5) {
      const Map<int, double> factorA = {
        1: 0.80, 2: 0.75, 3: 0.70, 4: 0.66, 5: 0.62,
        6: 0.59, 7: 0.56, 8: 0.53, 9: 0.51, 10: 0.49,
        11: 0.47, 12: 0.45, 13: 0.43, 14: 0.41, 15: 0.40,
        16: 0.39, 17: 0.38, 18: 0.37, 19: 0.36, 20: 0.35,
        21: 0.34, 22: 0.33, 23: 0.32, 24: 0.31, 25: 0.30,
      };
      final f = factorA[rCount] ?? 0.30;
      return (rRatingVA * rCount) * f;
    }

    if (kw <= 8.75) {
      const Map<int, double> factorB = {
        1: 0.80, 2: 0.65, 3: 0.55, 4: 0.50, 5: 0.45,
        6: 0.43, 7: 0.40, 8: 0.36, 9: 0.35, 10: 0.34,
        11: 0.32, 12: 0.32, 13: 0.32, 14: 0.32, 15: 0.32,
        16: 0.28, 17: 0.28, 18: 0.28, 19: 0.28, 20: 0.28,
        21: 0.26, 22: 0.26, 23: 0.26, 24: 0.26, 25: 0.26,
        26: 0.24, 27: 0.24, 28: 0.24, 29: 0.24, 30: 0.24,
        31: 0.22, 32: 0.22, 33: 0.22, 34: 0.22, 35: 0.22,
        36: 0.22, 37: 0.22, 38: 0.22, 39: 0.22, 40: 0.22,
        41: 0.20, 42: 0.20, 43: 0.20, 44: 0.20, 45: 0.20,
        46: 0.20, 47: 0.20, 48: 0.20, 49: 0.20, 50: 0.20,
        51: 0.18, 52: 0.18, 53: 0.18, 54: 0.18, 55: 0.18,
        56: 0.18, 57: 0.18, 58: 0.18, 59: 0.18, 60: 0.18,
      };
      final f = factorB[rCount] ?? 0.16;
      return (rRatingVA * rCount) * f;
    }

    double baseKW;
    if (rCount == 1)                        baseKW = 8.0;
    else if (rCount == 2)                   baseKW = 11.0;
    else if (rCount == 3)                   baseKW = 14.0;
    else if (rCount == 4)                   baseKW = 17.0;
    else if (rCount == 5)                   baseKW = 20.0;
    else if (rCount == 6)                   baseKW = 21.0;
    else if (rCount == 7)                   baseKW = 22.0;
    else if (rCount == 8)                   baseKW = 23.0;
    else if (rCount == 9)                   baseKW = 24.0;
    else if (rCount == 10)                  baseKW = 25.0;
    else if (rCount == 11)                  baseKW = 26.0;
    else if (rCount == 12)                  baseKW = 27.0;
    else if (rCount == 13)                  baseKW = 28.0;
    else if (rCount == 14)                  baseKW = 29.0;
    else if (rCount == 15)                  baseKW = 30.0;
    else if (rCount == 16)                  baseKW = 31.0;
    else if (rCount == 17)                  baseKW = 32.0;
    else if (rCount == 18)                  baseKW = 33.0;
    else if (rCount == 19)                  baseKW = 34.0;
    else if (rCount == 20)                  baseKW = 35.0;
    else if (rCount == 21)                  baseKW = 36.0;
    else if (rCount == 22)                  baseKW = 37.0;
    else if (rCount == 23)                  baseKW = 38.0;
    else if (rCount == 24)                  baseKW = 39.0;
    else if (rCount == 25)                  baseKW = 40.0;
    else if (rCount >= 26 && rCount <= 40)  baseKW = 15.0 + rCount.toDouble();
    else                                    baseKW = 25.0 + (rCount.toDouble() * 0.75);

    if (kw > 12.0) {
      final double excess = (kw - 12.0).ceil().toDouble();
      baseKW += (baseKW * (excess * 0.05));
    }
    return baseKW * 1000.0;
  }

  Map<String, dynamic> _calculateApplianceDemand() {
    double d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;

    final List<double> appVAs = applianceControllers
        .map((c) => d(c))
        .where((v) => v > 0)
        .toList();

    // ✅ শুধু 500va বা তার বেশি appliance count হবে
    final int countableAppliances = appVAs.where((va) => va >= 500).length;

    double demandVA = 0.0;
    final StringBuffer detailsBuffer = StringBuffer();

    if (countableAppliances >= 4) {
      detailsBuffer.writeln('4 or more countable appliances (500VA or more):');
      for (int i = 0; i < appVAs.length; i++) {
        final va = appVAs[i];
        if (va >= 500) {
          final demand = va * 0.75;
          demandVA += demand;
          detailsBuffer.writeln('  App ${i + 1}: ${va.toStringAsFixed(0)} VA (500+ at 75% = ${demand.toStringAsFixed(0)} VA)');
        } else {
          demandVA += va;
          detailsBuffer.writeln('  App ${i + 1}: ${va.toStringAsFixed(0)} VA (under 500 at 100%)');
        }
      }
    } else {
      demandVA = appVAs.fold(0.0, (a, b) => a + b);
      detailsBuffer.writeln('Less than 4 countable appliances (all 100%)');
      for (int i = 0; i < appVAs.length; i++) {
        detailsBuffer.writeln('  App ${i + 1}: ${appVAs[i].toStringAsFixed(0)} VA (100%)');
      }
    }

    return {
      'rawTotal': appVAs.fold(0.0, (a, b) => a + b),
      'count': appVAs.length,
      'demandVA': demandVA,
      'details': detailsBuffer.toString(),
    };
  }

  void calculateAmpacity() {
    double d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0.0;
    int i(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

    errorMessage = null;
    showResult   = false;

    final double area = d(areaController);
    if (area <= 0) {
      errorMessage = 'Please enter a valid area (Sq Ft).';
      update();
      return;
    }

    final double multiplier    = double.tryParse(multiplierController.text.trim()) ?? 2.0;
    final double baseGen       = (area * multiplier) + (i(appQtaController) * 1500.0) + (i(laodQtaController) * 1500.0);
    final double lightingResult = baseGen <= 3000 ? baseGen : 3000 + (baseGen - 3000) * 0.35;

    final double netDryerVA  = _calculateDryerDemand(i(dryerQtyController), d(dryerVaController));
    final double rangeResult = _calculateRangeDemand(i(rangeQtaController), d(rangeVaController));

    double totalAcVA = 0.0;
    for (final c in acUnitControllers) totalAcVA += d(c) * 1200.0;
    double totalHeatVA = 0.0;
    for (final c in heatingUnitControllers) totalHeatVA += d(c);
    final bool acGoverns       = totalAcVA >= totalHeatVA;
    final double hvacFinalLoad = acGoverns ? totalAcVA : totalHeatVA;

    final Map<String, double> motorMap = {};
    if (acGoverns) {
      for (int idx = 0; idx < acUnitControllers.length; idx++) {
        final va = d(acUnitControllers[idx]) * 1200.0;
        if (va > 0) motorMap['A/C Unit ${idx + 1}'] = va;
      }
    }
    final double poolVA = d(poolMotorController);
    if (poolVA > 0) motorMap['Pool Motor'] = poolVA;
    for (int idx = 0; idx < motorLoadControllers.length; idx++) {
      final va = d(motorLoadControllers[idx]);
      if (va > 0) motorMap['Motor ${idx + 1}'] = va;
    }

    double largestMotorValue = 0.0;
    String largestMotorName  = 'None Identified';
    motorMap.forEach((name, va) {
      if (va > largestMotorValue) { largestMotorValue = va; largestMotorName = name; }
    });

    final double motorIncr  = largestMotorValue * 0.25;
    final double acMotorSum = acGoverns ? totalAcVA : 0.0;
    final double netMotorVA = motorMap.values.fold(0.0, (a, b) => a + b) - acMotorSum;

    final applianceData      = _calculateApplianceDemand();
    final double applianceResult = applianceData['demandVA'];
    final int    appCount        = applianceData['count'];
    final double appRawTotal     = applianceData['rawTotal'];
    final String appDetails      = applianceData['details'];

    double rawEvVA = 0.0;
    for (final c in evChargerControllers) rawEvVA += d(c);
    final double evResult = rawEvVA * 1.25;

    final double totalLoad  = lightingResult + netDryerVA + rangeResult + applianceResult + hvacFinalLoad + netMotorVA + motorIncr + evResult;
    final double serviceAmps = totalLoad / 240.0;

    final sb = StringBuffer()
      ..writeln('General Lighting/Small App: ${lightingResult.toStringAsFixed(0)} VA')
      ..writeln('Range Demand: ${rangeResult.toStringAsFixed(0)} VA')
      ..writeln('Dryer Demand: ${netDryerVA.toStringAsFixed(0)} VA')
      ..writeln('Fixed Appliances ($appCount items):')
      ..writeln('  Raw Total: ${appRawTotal.toStringAsFixed(0)} VA')
      ..writeln('  Details: ${appDetails.trim()}')
      ..writeln('  Final Demand: ${applianceResult.toStringAsFixed(0)} VA')
      ..writeln('Other Motor Loads (100%): ${netMotorVA.toStringAsFixed(0)} VA')
      ..writeln('HVAC Load (${acGoverns ? "A/C" : "Heat"} governs): ${hvacFinalLoad.toStringAsFixed(0)} VA')
      ..writeln('Largest Motor Increase (+25% on $largestMotorName): ${motorIncr.toStringAsFixed(0)} VA')
      ..writeln('EV Charger (125%): ${evResult.toStringAsFixed(0)} VA')
      ..writeln('----------------------------')
      ..writeln('TOTAL SERVICE LOAD: ${totalLoad.toStringAsFixed(0)} VA');

    totalVA         = totalLoad;
    resultAmpacity  = serviceAmps;
    resultBreakdown = sb.toString();
    showResult      = true;
    update();
  }

  @override
  void onClose() {
    areaController.dispose();
    multiplierController.dispose();
    appQtaController.dispose();
    laodQtaController.dispose();
    rangeQtaController.dispose();
    rangeVaController.dispose();
    dryerQtyController.dispose();
    dryerVaController.dispose();
    poolMotorController.dispose();
    for (final c in [
      ...acUnitControllers, ...heatingUnitControllers,
      ...motorLoadControllers, ...evChargerControllers,
      ...applianceControllers
    ]) { c.dispose(); }
    super.onClose();
  }
}