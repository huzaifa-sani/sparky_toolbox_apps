import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/dwelling_controller.dart';

class DwellingScreen extends StatelessWidget {
  const DwellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Dwelling Load Standard Calc',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.find<DwellingController>().resetAll(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: GetBuilder<DwellingController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0).copyWith(top: 8),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  16.height,

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Area (Sq Ft)',
                          controller: controller.areaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      20.width,
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Watt Per (Sq Ft)',
                          controller: controller.multiplierController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  20.height,

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Small App Qty',
                          controller: controller.appQtaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      20.width,
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Laundry Qty',
                          controller: controller.laodQtaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  20.height,

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Range Qty',
                          controller: controller.rangeQtaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      20.width,
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Range VA (ea)',
                          controller: controller.rangeVaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  20.height,

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Dryer Qty',
                          controller: controller.dryerQtyController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      20.width,
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Dryer VA (ea)',
                          controller: controller.dryerVaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  20.height,

                  const CommonText(text: 'A/C Units (Tons)', bottom: 20),

                  ...List.generate(controller.acUnitCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              labelText: 'A/C Unit ${index + 1} Tons',
                              controller: controller.acUnitControllers[index],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (controller.acUnitCount > 1)
                            IconButton(
                              onPressed: controller.removeACUnits,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.red,
                            ),
                        ],
                      ),
                    );
                  }),

                  CommonButton(
                    titleText: 'Add A/C Unit',
                    buttonRadius: 30,
                    buttonHeight: 40,
                    titleColor: AppColors.white,
                    buttonColor: AppColors.transparent,
                    borderColor: AppColors.white,
                    titleWeight: FontWeight.w500,
                    onTap: controller.addAcUnit,
                  ),

                  // ── Heating Units ─────────────────────────────
                  const CommonText(
                    text: 'Heating Units (VA)',
                    bottom: 20,
                    top: 20,
                  ),
                  ...List.generate(controller.heatingUnitCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              labelText: 'Heating Unit ${index + 1} VA',
                              controller:
                              controller.heatingUnitControllers[index],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (controller.heatingUnitCount > 1)
                            IconButton(
                              onPressed: controller.removeHeatingUnit,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.red,
                            ),
                        ],
                      ),
                    );
                  }),
                  20.height,
                  CommonButton(
                    titleText: 'Add Heating Unit',
                    buttonRadius: 30,
                    buttonHeight: 40,
                    buttonColor: AppColors.transparent,
                    borderColor: AppColors.white,
                    titleColor: AppColors.white,
                    titleWeight: FontWeight.w500,
                    onTap: controller.addHeatingUnit,
                  ),

                  // ── Motor Loads ───────────────────────────────
                  const CommonText(
                    text: 'Motor Loads (VA)',
                    top: 20,
                    bottom: 20,
                  ),
                  CommonTextField(
                    labelText: 'Pool Motor VA',
                    controller: controller.poolMotorController,
                    keyboardType: TextInputType.number,
                  ),
                  20.height,
                  ...List.generate(controller.motorLoadCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              labelText:
                              'Additional Motor Load ${index + 1} VA',
                              controller:
                              controller.motorLoadControllers[index],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (controller.motorLoadCount > 1)
                            IconButton(
                              onPressed: controller.removeMotorLoad,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.red,
                            ),
                        ],
                      ),
                    );
                  }),
                  CommonButton(
                    titleText: 'Add Motor Load',
                    buttonRadius: 30,
                    buttonHeight: 40,
                    buttonColor: AppColors.transparent,
                    borderColor: AppColors.white,
                    titleColor: AppColors.white,
                    titleWeight: FontWeight.w500,
                    onTap: controller.addMotorLoad,
                  ),

                  // ── EV Charger ────────────────────────────────
                  const CommonText(
                    text: 'EV Charger (VA)',
                    top: 20,
                    bottom: 20,
                  ),
                  ...List.generate(controller.evChargerCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              labelText: 'EV Charger ${index + 1} VA',
                              controller:
                              controller.evChargerControllers[index],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (controller.evChargerCount > 1)
                            IconButton(
                              onPressed: controller.removeEVUnits,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.red,
                            ),
                        ],
                      ),
                    );
                  }),
                  CommonButton(
                    titleText: 'Add EV Charger',
                    buttonRadius: 30,
                    buttonColor: AppColors.transparent,
                    borderColor: AppColors.white,
                    titleColor: AppColors.white,
                    titleWeight: FontWeight.w500,
                    onTap: controller.addEvCharger,
                  ),

                  // ── General Appliances ────────────────────────
                  const CommonText(
                    text: 'General Appliances (VA)',
                    top: 20,
                    bottom: 20,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  ...List.generate(controller.applianceCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              labelText: 'Appliance ${index + 1} VA',
                              controller:
                              controller.applianceControllers[index],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (controller.applianceCount > 1)
                            IconButton(
                              onPressed: controller.removeAppliance,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.red,
                            ),
                        ],
                      ),
                    );
                  }),
                  CommonButton(
                    titleText: 'Add Appliance',
                    buttonRadius: 30,
                    buttonColor: AppColors.transparent,
                    borderColor: AppColors.white,
                    titleColor: AppColors.white,
                    titleWeight: FontWeight.w500,
                    onTap: controller.addAppliance,
                  ),

                  20.height,

                  if (controller.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                      child: CommonText(
                        text: controller.errorMessage!,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    12.height,
                  ],

                  CommonButton(
                    titleText: 'Calculate Service Load',
                    buttonRadius: 30,
                    onTap: controller.calculateAmpacity,
                  ),
                  20.height,

                  if (controller.showResult && controller.resultAmpacity != null)
                    _buildResultCard(controller),

                  10.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Result card shown inline below calculate button ───────────
  Widget _buildResultCard(DwellingController controller) {
    final amps = controller.resultAmpacity!;
    final total = controller.totalVA!;

    const sizes = [100, 125, 150, 175, 200, 225, 250, 300, 400];
    final breaker = sizes.firstWhere((s) => s >= amps, orElse: () => 400);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BFA5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Load: ${total.toStringAsFixed(0)} VA',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Service: ${amps.toStringAsFixed(1)} A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFA5),
            ),
          ),

          const Divider(height: 24, color: Color(0xFF1E3A3A)),

          Text(
            controller.resultBreakdown,
            style: const TextStyle(
              fontSize: 13,
              height: 1.7,
              color: Color(0xFF80CBC4),
            ),
          ),

          //const SizedBox(height: 12),

          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF00BFA5).withOpacity(0.12),
          //     borderRadius: BorderRadius.circular(10),
          //     border: Border.all(color: const Color(0xFF00BFA5), width: 1.2),
          //   ),
          //   child: Row(
          //     children: [
          //       const Icon(Icons.electric_bolt,
          //           color: Color(0xFF00BFA5), size: 22),
          //       const SizedBox(width: 10),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text(
          //             'Recommended Main Breaker',
          //             style: TextStyle(
          //                 fontSize: 11, color: Color(0xFF80CBC4)),
          //           ),
          //           Text(
          //             '$breaker Amp',
          //             style: const TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF00BFA5),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: controller.generatePDF,
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text(
              'Export PDF',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
